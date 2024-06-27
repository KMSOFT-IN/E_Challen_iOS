//
//  SplashViewController.swift
//  E_Challen
//
//  Created by KMSOFT on 21/06/24.
//

import UIKit

class SplashViewController: UIViewController, UITextViewDelegate {

    
    
    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var continueBtton: UIButton!
    
    var isCheck:Bool = false
    var privacyLink = URL(string: "https://www.termsfeed.com/live/419bed76-acf9-43a3-94b3-0b58cfbe493d")
    var webViewLink = URL(string: "https://www.suratcitypolice.org/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.isEditable = false
        textView.isSelectable = true
        
        let text = "I understand this is not a government App and I Read data "
        let privacyPolicy = "Privacy Policy & terms and Conditions."
        
        let appColor = UIColor(
            red: CGFloat(0x41) / 255.0,
            green: CGFloat(0x68) / 255.0,
            blue: CGFloat(0xE7) / 255.0,
            alpha: 1.0
        )
        let blackColor = UIColor.black.withAlphaComponent(0.5)
        let boldFont = UIFont.boldSystemFont(ofSize: 12.0)
        
        let attributedText = NSMutableAttributedString(string: text, attributes: [.foregroundColor: blackColor])
        let privacyPolicyAttributedString = NSAttributedString(string: privacyPolicy, attributes: [
            .foregroundColor: appColor,
            .link: "privacyPolicy",
            .font: boldFont
        ])
        
        attributedText.append(privacyPolicyAttributedString)
        
        textView.attributedText = attributedText
        textView.linkTextAttributes = [
            .foregroundColor: appColor,
            .font: boldFont
        ]
        
        textView.attributedText = attributedText
        
        textViewDescription.delegate = self
        textViewDescription.isEditable = false
        textViewDescription.isSelectable = true
        
        let text1 = "Not a Government app : Surat E Memo App is an independent platform and is not affiliated with any GOVERNMENT authority in india. The vehicle details shown in the app are publicly available on the website "
        let privacyPolicy1 = "(https://www.suratcitypolice.org/)."
        let text2 = " This app is maintained and owned by a private entity"
        
        let attributedText1 = NSMutableAttributedString(string: text1, attributes: [.foregroundColor: blackColor])
        let privacyPolicyText1 = NSAttributedString(string: privacyPolicy1, attributes: [
            .foregroundColor: appColor,
            .link: "webViewLink",
            .font: boldFont
        ])
        let attributedText2 = NSMutableAttributedString(string: text2, attributes: [.foregroundColor: blackColor])
        
        attributedText1.append(privacyPolicyText1)
        attributedText1.append(attributedText2)
        
        textViewDescription.attributedText = attributedText1
        textViewDescription.linkTextAttributes = [
            .foregroundColor: appColor,
            .font: boldFont
        ]
        
        textViewDescription.attributedText = attributedText1
        
        self.continueBtton.isEnabled = false
        self.continueBtton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "privacyPolicy" {
            if let url = privacyLink {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                return false
            } else {
                print("Invalid URL")
                return true
            }
        }
        if URL.absoluteString == "webViewLink" {
            if let url = webViewLink {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                return false
            } else {
                print("Invalid URL")
                return true
            }
        }
        return false
    }
    
    static func getInstance() -> SplashViewController {
        return Constant.Storyboard.MAIN.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "ic_check_blue") {
              sender.setImage(UIImage(named: "ic_uncheck_blue"), for: .normal)
            self.isCheck = false
            self.continueBtton.isEnabled = false
            self.continueBtton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
          } else {
              sender.setImage(UIImage(named: "ic_check_blue"), for: .normal)
              self.isCheck = true
              self.continueBtton.isEnabled = true
              self.continueBtton.backgroundColor = UIColor(named: "AppColor")
          }
    }
    
    @IBAction func continueButtontapped(_ sender: Any) {
        let vc = HomeViewController.getInstance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


