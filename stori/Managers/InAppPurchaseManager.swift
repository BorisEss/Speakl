//
//  InAppPurchaseManager.swift
//  stori
//
//  Created by Alex on 20.04.2021.
//

import Foundation
import StoreKit
import SwiftyStoreKit
import PromiseKit

/// Registered Purchases - a list of purchases already registered in Appstore Connect
/// When registering an `In App Purchase` item the Product ID should be (Bundle ID) + an
/// unique ID which represents the item.
///
/// To show all cases in an array use `RegisteredPurchases.allCases`
///
enum RegisteredPurchases: String, CaseIterable {
    case monthlySubscription    = "ideaction.io.stori.monthly"
    case quaterlySubscription   = "ideaction.io.stori.quarterly"
    case yearlySubscription     = "ideaction.io.stori.annual"
}

/// `InAppPurchaseManager` - Quick and simple manager for downloading
/// Items from AppStore then purchasing different items from Store.
///
class InAppPurchaseManager {
    
    public static var shared = InAppPurchaseManager()
    
    /// This value determines if purchases should be delivered through server
    /// or purchases are delivered imediatelly.
    /// `true` value means that purchases will be delivered immediatelly.
    private var atomicPurchases = false
    
    /// All Producrs downloaded from App Store.
    private(set) var products: [SKProduct] = []
    
    init() {
        retreiveProducts()
    }
    
    /// Retreiving all products with registered bundle id's from AppStore connect and saving items in `products` value.
    ///
    private func retreiveProducts() {
        let productsIds: Set<String> = Set(RegisteredPurchases.allCases.map { $0.rawValue })
        SwiftyStoreKit.retrieveProductsInfo(productsIds) { result in
            if !result.retrievedProducts.isEmpty {
                #if DEBUG
                for item in result.retrievedProducts {
                    let priceString = item.localizedPrice ?? "(No Price available)"
                    print("InAppPurchasesManager -> Product: \(item.localizedTitle), price: \(priceString)")
                }
                #endif
                self.products = result.retrievedProducts.sorted(by: {
                    Double(truncating: $0.price) < Double(truncating: $1.price)
                })
            }
            #if DEBUG
            if !result.invalidProductIDs.isEmpty {
                for item in result.invalidProductIDs {
                    print("InAppPurchasesManager -> Invalid product identifier: \(item)")
                }
            }
            if let error = result.error {
                print("InAppPurchasesManager -> Error: \(error)")
            }
            #endif
        }
    }
    
    /// Apple recommends to register a transaction observer as soon as the app starts, so completeTransactions should
    /// be called SHOULD ONLY be called once in your code, in application(:didFinishLaunchingWithOptions:).
    ///
    /// If there are any pending transactions at this point, these will be reported by the completion block
    /// so that the app state and UI can be updated.
    ///
    /// If there are no pending transactions, the completion block will not be called.
    ///
    public func completeTransactions() {
        if KeychainManager.shared.isLoggedIn() {
            self.checkReceipt().cauterize()
        }
        SwiftyStoreKit.completeTransactions(atomically: atomicPurchases) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased :
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                case .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                case .failed, .purchasing, .deferred:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
    
    /// Purchasing a specified product.
    ///
    /// - Parameters:
    ///     - product : `SKProduct` - specific product that should be bought.
    ///     - quantity : `Int` - Number of items which should be bought, by default is 1 item.
    /// - Returns: `Promise` that purchase was successfull
    ///
    public func purchase(product: SKProduct,
                         quantity: Int = 1) -> Promise<Void> {
        return Promise<Void> { promise in
            let username = Storage.shared.currentLanguage?.name ?? ""
            SwiftyStoreKit.purchaseProduct(product,
                                           quantity: quantity,
                                           atomically: atomicPurchases,
                                           applicationUsername: username) { (result) in
                switch result {
                case .success(let product):
                    self.checkReceipt()
                        .done { (_) in
                            if product.needsFinishTransaction {
                                SwiftyStoreKit.finishTransaction(product.transaction)
                            }
                            promise.fulfill_()
                        }
                        .catch { (error) in
                            promise.reject(error)
                        }
                case .error(let error):
                    promise.reject(error)
                }
            }
        }
    }
    
    private func checkReceipt() -> Promise<Void> {
        if let receiptData = SwiftyStoreKit.localReceiptData {
            let receiptString = receiptData.base64EncodedString(options: [])
            return UserClient.verifySubscription(receipt: receiptString)
        } else {
            return Promise<Void> { promise in promise.fulfill_() }
        }
    }
}
