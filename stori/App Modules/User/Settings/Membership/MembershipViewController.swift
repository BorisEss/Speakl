//
//  MembershipViewController.swift
//  stori
//
//  Created by Alex on 19.04.2021.
//

import UIKit
import StoreKit

class MembershipViewController: UIViewController {

    @IBOutlet weak var subscriptionsCollectionView: UICollectionView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var subscribeButton: RegularButton!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    @IBAction func subscribeButtonPressed(_ sender: Any) {
        if let index = subscriptionsCollectionView.indexPathsForSelectedItems?.first {
            let item = InAppPurchaseManager.shared.products[index.row]
            subscribeButton.isHidden = true
            progressActivityIndicator.startAnimating()
            subscriptionsCollectionView.isUserInteractionEnabled = false
            InAppPurchaseManager.shared.purchase(product: item)
                .ensure {
                    self.subscribeButton.isHidden = false
                    self.progressActivityIndicator.stopAnimating()
                    self.subscriptionsCollectionView.isUserInteractionEnabled = true
                }
                .done { (_) in
                    Toast.success("membership_success".localized)
                    self.navigationController?.popViewController(animated: true)
                }
                .catch { (error) in
                    if let error = error as? SKError,
                       error.code != .paymentCancelled {
                        error.parse()
                    }
                }
        }
    }
    
    private func setUpLanguage() {
        title = "membership_title".localized
    }
}

extension MembershipViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return InAppPurchaseManager.shared.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MembershipCollectionViewCell",
                                                      for: indexPath)
        if let cell = mainCell as? MembershipCollectionViewCell {
            cell.setUp(item: InAppPurchaseManager.shared.products[indexPath.row])
            if let subscriptionId = Storage.shared.currentUser?.subscriptionId,
               InAppPurchaseManager.shared.products[indexPath.row].productIdentifier == subscriptionId {
                cell.disable()
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let delay = Double(indexPath.row) * 0.3
        cell.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            Vibration().light()
        }
        UIView.animate(withDuration: 1,
                       delay: delay,
                       options: .curveEaseOut,
                       animations: {
          cell.alpha = 1
                       })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Vibration().light()
        subscribeButton.isEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let subscriptionId = Storage.shared.currentUser?.subscriptionId {
            return InAppPurchaseManager.shared.products[indexPath.row].productIdentifier != subscriptionId
        }
        return true
    }
}

extension MembershipViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 96, height: 142)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        let totalCellWidth = 96 * InAppPurchaseManager.shared.products.count
        let totalSpacingWidth = 10 * (InAppPurchaseManager.shared.products.count - 1)

        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}
