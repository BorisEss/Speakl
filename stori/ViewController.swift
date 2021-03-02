//
//  ViewController.swift
//  stori
//
//  Created by Alex on 16.11.2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var continueButton: RegularButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.2
        navigationController?.navigationBar.layer.shadowRadius = 8
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 8)
        
        if let tnStatus = Storage.shared.currentUser?.teacherExperience?.status {
            switch tnStatus {
            case .inReview:
                continueButton.setTitle("Check Status", for: .normal)
            case .approved:
                continueButton.setTitle("Create Sotry", for: .normal)
            }
        } else {
            continueButton.setTitle("Register to Teacher Network", for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVc = segue.destination as? JoinTNSuccessMessageViewController {
            nextVc.isCheck = true
            nextVc.hidesBottomBarWhenPushed = true
        }
    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        if let tnStatus = Storage.shared.currentUser?.teacherExperience?.status {
            switch tnStatus {
            case .inReview:
                performSegue(withIdentifier: "check", sender: nil)
            case .approved:
                performSegue(withIdentifier: "create", sender: nil)
            }
        } else {
            performSegue(withIdentifier: "register", sender: nil)
        }
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        Storage.shared.currentUser = nil
        KeychainManager.shared.token = nil
        Router.load()
    }
}
