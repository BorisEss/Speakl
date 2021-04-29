//
//  InviteFriendsViewController.swift
//  stori
//
//  Created by Alex on 29.04.2021.
//

import UIKit

class InviteFriendsViewController: UIViewController {

    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var codeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "invite_friends_title".localized
        loadData()
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

    @IBAction func codeButtonPressed(_ sender: Any) {
        if let code = Storage.shared.currentUser?.referralCode {
            UIPasteboard.general.string = "\(code)"
            Toast.success("invite_friends_code_copied_to_clipboard".localized)
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        guard let username = Storage.shared.currentUser?.username,
              let code = Storage.shared.currentUser?.referralCode else { return }
        let text = String(format: "invite_friends_share_message".localized,
                          username,
                          Endpoints.appStore,
                          "\(code)")
        
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare,
                                                              applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func loadData() {
        if let code = Storage.shared.currentUser?.referralCode {
            qrCodeImageView.image = UIImage.generateQRCode(from: "\(code)")
            codeButton.setTitle("\(code)", for: .normal)
        }
    }
}
