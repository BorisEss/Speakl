//
//  JoinTNAgreementViewController.swift
//  stori
//
//  Created by Alex on 05.01.2021.
//

import UIKit

class JoinTNAgreementViewController: UIViewController {
    
    private let segueToTermsAndConditions = "showTermsAndConditions"
    private let segueToPrivacyPolicy = "showPrivacyPolicy"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var termsAndConditionsButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var agreeButton: RegularButton!
    @IBOutlet weak var declineButton: RegularButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLanguage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToTermsAndConditions,
           let webController = segue.destination as? WebBrowserViewController {
            webController.url = Endpoints.termsAndConditions
            webController.title = "common_terms_and_conditions".localized
        }
        if segue.identifier == segueToPrivacyPolicy,
           let webController = segue.destination as? WebBrowserViewController {
            webController.url = Endpoints.privacyPolicy
            webController.title = "common_privacy_policy".localized
        }
    }

    @IBAction func declinePressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setUpLanguage() {
        title = "join_tn_agreement_navbar_title".localized
        titleLabel.text = "join_tn_agreement_title".localized
        descriptionLabel.text = "join_tn_agreement_description".localized
        termsAndConditionsButton.setTitle("common_terms_and_conditions".localized,
                                          for: .normal)
        privacyPolicyButton.setTitle("common_privacy_policy".localized,
                                     for: .normal)
        agreeButton.setTitle("join_tn_agreement_agree_button".localized,
                             for: .normal)
        declineButton.setTitle("join_tn_agreement_decline_button".localized,
                               for: .normal)
    }
}
