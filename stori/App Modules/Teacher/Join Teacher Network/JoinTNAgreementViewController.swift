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
            webController.title = "Terms & Conditions"
        }
        if segue.identifier == segueToPrivacyPolicy,
           let webController = segue.destination as? WebBrowserViewController {
            webController.url = Endpoints.privacyPolicy
            webController.title = "Privacy Policy"
        }
    }

    @IBAction func declinePressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setUpLanguage() {
        // TODO: Finish translations
        title = "Join our Teacher Network"
        titleLabel.text = "Review Terms & Conditons"
//        descriptionLabel.text = ""
        termsAndConditionsButton.setTitle("Terms & Conditions", for: .normal)
        privacyPolicyButton.setTitle("Privacy Policy", for: .normal)
        agreeButton.setTitle("Agree with this", for: .normal)
        declineButton.setTitle("Decline", for: .normal)
    }
}
