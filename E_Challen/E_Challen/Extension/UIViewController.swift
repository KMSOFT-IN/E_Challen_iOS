//
//  UIViewController.swift
//  PaintInTheCity
//
//  Created by KMSOFT on 04/09/20.
//  Copyright © 2020 KMSOFT. All rights reserved.
//
//
//import Foundation
//import UIKit
//import AuthenticationServices

import UIKit
////import FirebaseAuth
////import CryptoKit
////import Photos
//
//extension UIViewController : ASAuthorizationControllerDelegate , ASAuthorizationControllerPresentationContextProviding {
//    static var currentNonce: String? = ""
//    
//    func showAlert(title: String, message: String, okTitle: String = "Ok", cancelTitle: String? = nil, oKCallback: (() -> Void)? = nil, cancelCallback: (() -> Void)? = nil) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: {(alertAction) in
//            oKCallback?()
//        }))
//        if cancelTitle != nil {
//            alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: {(alertAction) in
//                cancelCallback?()
//            }))
//        }
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//  
//     func alert(message: String, title: String? = APPNAME) {
//        DispatchQueue.main.async {
//            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            let okString = "OK"
//            let action = UIAlertAction(title: okString, style: .cancel, handler: nil)
//            alert.addAction(action)
//           // alert.shows()
//        }
//    }
//    
//    
//    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window!
//    }
//    
//    func randomNonceString(length: Int = 32) -> String {
//        precondition(length > 0)
//        let charset: Array<Character> =
//            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
//        var result = ""
//        var remainingLength = length
//        
//        while remainingLength > 0 {
//            let randoms: [UInt8] = (0 ..< 16).map { _ in
//                var random: UInt8 = 0
//                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
//                if errorCode != errSecSuccess {
//                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
//                }
//                return random
//            }
//            
//            randoms.forEach { random in
//                if remainingLength == 0 {
//                    return
//                }
//                
//                if random < charset.count {
//                    result.append(charset[Int(random)])
//                    remainingLength -= 1
//                }
//            }
//        }
//        
//        return result
//    }
//    
//   
//    func topMostViewController() -> UIViewController? {
//        if self.presentedViewController == nil {
//            return self
//        }
//        if let navigation = self.presentedViewController as? UINavigationController {
//            return navigation.visibleViewController?.topMostViewController()
//        }
//        if let tab = self.presentedViewController as? UITabBarController {
//            if let selectedTab = tab.selectedViewController {
//                return selectedTab.topMostViewController()
//            }
//            return tab.topMostViewController()
//        }
//        return self.presentedViewController!.topMostViewController()
//    }
//}
//
//extension UIViewController: UIGestureRecognizerDelegate {
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
//                                  shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//}
//
extension UIViewController {
    
    func configureChildViewController(childController: UIViewController, onView: UIView) {
        onView.removeAllSubviews()
        self.addChild(childController)
        onView.addSubview(childController.view)

        childController.view.frame = onView.bounds
        childController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        constrainViewEqual(holderView: onView, view: childController.view)
        childController.didMove(toParent: self)
        childController.willMove(toParent: self)
    }

    func configureChildViewController1(childController: UIViewController, onView: UIView) {
        onView.removeAllSubviews()
        self.addChild(childController)
        onView.addSubview(childController.view)

        // Make sure childController's view matches its container's size
        childController.view.frame = onView.bounds
        childController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        constrainViewEqual(holderView: onView, view: childController.view)

        childController.didMove(toParent: self)
        childController.willMove(toParent: self)
    }

   
    func constrainViewEqual(holderView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        //pin 100 points from the top of the super
        let pinTop = NSLayoutConstraint(item: view,
                                        attribute: .top,
                                        relatedBy: .equal,
                                        toItem: holderView,
                                        attribute: .top,
                                        multiplier: 1.0,
                                        constant: 0)
        let pinBottom = NSLayoutConstraint(item: view,
                                           attribute: .bottom,
                                           relatedBy: .equal,
                                           toItem: holderView,
                                           attribute: .bottom,
                                           multiplier: 1.0,
                                           constant: 0)
        let pinLeft = NSLayoutConstraint(item: view,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: holderView,
                                         attribute: .left,
                                         multiplier: 1.0,
                                         constant: 0)
        let pinRight = NSLayoutConstraint(item: view,
                                          attribute: .right,
                                          relatedBy: .equal,
                                          toItem: holderView,
                                          attribute: .right,
                                          multiplier: 1.0,
                                          constant: 0)
        holderView.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
    }
}

extension UIView {
    
    func removeAllSubviews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    func removeImageView() {
        for view in self.subviews {
            if let imageView = view as? UIImageView {
                imageView.removeFromSuperview()
            }
        }
    }
    
    func checkIfContainImageView() -> Bool {
        for view in self.subviews[0].subviews {
            if let _ = view as? UIImageView {
                return true
            }
        }
        return false
    }
    
}
