//
//  RedeemCodeViewController.swift
//  stori
//
//  Created by Alex on 29.04.2021.
//

import UIKit
import QRCodeReader
import AVFoundation

class RedeemCodeViewController: UIViewController {

    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = false
            $0.showOverlayView        = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var scanButton: RegularButton!
    @IBOutlet weak var redeemButton: RegularButton!
    @IBOutlet weak var progressActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "redeem_code_title".localized
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
    @IBAction func scanQRCodePressed(_ sender: Any) {
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let code = result?.value {
                self.codeTextField.text = code
                self.checkField()
            }
            self.readerVC.dismiss(animated: true, completion: nil)
          }
        readerVC.modalPresentationStyle = .pageSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    @IBAction func redeemButtonPressed(_ sender: Any) {
        if let code = codeTextField.text,
           !code.isEmpty {
            codeTextField.isEnabled = false
            scanButton.isEnabled = false
            redeemButton.isHidden = true
            progressActivityIndicator.startAnimating()
            RedeemService.redeemCode(code: code)
                .ensure {
                    self.codeTextField.isEnabled = true
                    self.scanButton.isEnabled = true
                    self.redeemButton.isHidden = false
                    self.progressActivityIndicator.stopAnimating()
                }
                .done { _ in
                    self.codeTextField.text = nil
                    Toast.success("redeem_code_success_message".localized)
                    self.navigationController?.popViewController(animated: true)
                }
                .catch { error in
                    error.parse()
                }
        }
    }
    
    private func checkField() {
        if codeTextField.text?.isEmpty ?? true {
            redeemButton.isEnabled = false
        } else {
            redeemButton.isEnabled = true
        }
    }
}

extension RedeemCodeViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkField()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
