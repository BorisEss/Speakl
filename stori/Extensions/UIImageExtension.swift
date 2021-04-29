//
//  UIImageExtension.swift
//  stori
//
//  Created by Alex on 19.11.2020.
//

import UIKit
import SDWebImage
import PromiseKit

extension UIImage {
    static func downloadImage(url: String) -> Promise<UIImage> {
        return Promise<UIImage> { promise in
            SDWebImageManager.shared.loadImage(
                with: URL(string: url),
                options: .highPriority,
                progress: nil,
                completed: { (image, _, error, _, _, _) in
                    if let err = error {
                        promise.reject(err)
                        return
                    }
                    guard let img = image else {
                        promise.reject(NetworkError.unknownError)
                        return
                    }
                    promise.fulfill(img)
                }
            )
        }
    }
    
    static func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}
