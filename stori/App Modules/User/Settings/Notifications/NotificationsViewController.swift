//
//  NotificationsViewController.swift
//  stori
//
//  Created by Alex on 27.04.2021.
//

import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet weak var notificationsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "edit_notifications_title".localized
        notificationsSwitch.isOn = Storage.shared.currentUser?.notificationsEnabled ?? false
        if notificationsSwitch.isOn {
            notificationsSwitch.thumbTintColor = .speaklAccentColor
        } else {
            notificationsSwitch.thumbTintColor = .speaklWhite
        }
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

    @IBAction func notificationsSwitchChanged(_ sender: UISwitch) {
        Vibration().light()
        if sender.isOn {
            sender.thumbTintColor = .speaklAccentColor
        } else {
            sender.thumbTintColor = .speaklWhite
        }
        UserClient.updateNotifications(enabled: sender.isOn)
            .cauterize()
    }
}
