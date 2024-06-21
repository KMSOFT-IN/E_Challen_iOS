//
//  Alert.swift
//  ExpenseManager
//
//  Created by Kmsoft on 09/03/24.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController {
    func showAlertWithAction(title: String?, message: String?, buttonText: String?, completion: (() -> Void)? = nil, actionHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        
        if let buttonText = buttonText {
            let buttonAction = UIAlertAction(title: buttonText, style: .default) { _ in
                actionHandler?()
            }
            alertController.addAction(buttonAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
}
