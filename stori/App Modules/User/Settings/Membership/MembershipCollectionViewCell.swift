//
//  MembershipCollectionViewCell.swift
//  stori
//
//  Created by Alex on 20.04.2021.
//

import UIKit
import StoreKit

class MembershipCollectionViewCell: UICollectionViewCell {
    
    private var item: SKProduct?
    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var topBadgeView: UIView!
    @IBOutlet weak var badgeLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                cellView.borderWidth = 2
                cellView.borderColor = .speaklAccentColor
            } else {
                cellView.borderWidth = 0
                cellView.borderColor = .clear
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let item = item {
            setUp(item: item)
        }
    }
    
    func setUp(item: SKProduct) {
        self.item = item
        if item.productIdentifier == RegisteredPurchases.monthlySubscription.rawValue {
            topBadgeView.isHidden = true
            discountLabel.text = " "
            discountLabel.isHidden = true
        } else {
            let products = InAppPurchaseManager.shared.products
            let monthlySubscriptionIdentifier = RegisteredPurchases.monthlySubscription.rawValue
            if let monthlySubscription = products.first(where: {
                $0.productIdentifier == monthlySubscriptionIdentifier
            }) {
                var totalPrice: Double = Double(truncating: monthlySubscription.price)
                if item.productIdentifier == RegisteredPurchases.quaterlySubscription.rawValue {
                    totalPrice = Double(truncating: monthlySubscription.price) * 3
                    topBadgeView.backgroundColor = .speaklGreen
                }
                if item.productIdentifier == RegisteredPurchases.yearlySubscription.rawValue {
                    totalPrice = Double(truncating: monthlySubscription.price) * 12
                    topBadgeView.backgroundColor = .speaklRed
                    
                }
                let oldPrice = Number.format(price: totalPrice, locale: item.priceLocale)
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(oldPrice)")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                             value: 1,
                                             range: NSRange(location: 0, length: attributeString.length))
                discountLabel.attributedText = attributeString
                let percentage = "\(100 - Int(Double(truncating: item.price)*100/totalPrice))"
                badgeLabel.text = String(format: "membership_save_label".localized, percentage)
                topBadgeView.isHidden = false
                discountLabel.isHidden = false
            } else {
                topBadgeView.isHidden = true
                discountLabel.isHidden = true
            }
        }
        priceLabel.text = item.localizedPrice
        titleLabel.text = item.localizedDescription.replacingOccurrences(of: " ", with: "\n")
    }
    
    func disable() {
        cellView.alpha = 0.9
        topBadgeView.isHidden = false
        topBadgeView.backgroundColor = .speaklAccentColor
        badgeLabel.text = "membership_active_label".localized
        cellView.backgroundColor = UIColor.speaklAccentColor.withAlphaComponent(0.15)
    }
}
