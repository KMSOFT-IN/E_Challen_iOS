//
//  SettingViewController.swift
//  Surat E Memo
//
//  Created by KMSOFT on 27/06/24.
//

import UIKit
import StoreKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var data = ["Privacy Policy","Rate us","Share us"]
    var privacyLink = URL(string: "https://www.termsfeed.com/live/831df050-08e4-4362-82d5-96f4a63acf6e")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
        self.versionLabel.text = "Version \(getAppVersion())"
    }
    
    @IBAction func backButtontapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    static func getInstance() -> SettingViewController {
        return Constant.Storyboard.MAIN.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
    }
    
    func getAppVersion() -> String {
        guard let buildNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "Unknown Build Number"
        }
        return buildNumber
    }
    
    func shareApp() {
        let message = "Sharing this from my app!"
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let urls: [URL] = []
        
        var formattedURLs: [String] = []
        
        formattedURLs.append(message)
        
        for url in urls {
            let platform: String
            if url.absoluteString.contains("apps.apple.com") {
                platform = "iOS APP:"
            } else if url.absoluteString.contains("play.google.com") {
                platform = "ANDROID APP:"
            } else {
                platform = "Unknown Platform:"
            }
            
            let formattedURL = "\(platform) \(url)"
            formattedURLs.append(formattedURL)
        }
        
        let formattedString = formattedURLs.joined(separator: "\n")
        print(formattedString)
        
        
        UIGraphicsEndImageContext()
        //        let objectsToShare = [urls as Any, self] as [Any]
        let objectsToShare: [Any] = [formattedString]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        activityVC.popoverPresentationController?.sourceView = self.view //sender as? UIView
        self.present(activityVC, animated: true, completion: nil)
        
    }
    func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
            
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "6458187046") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
}
extension SettingViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        let d = self.data[indexPath.row]
        cell.vehicleNumber.text = d
        //    cell.adImage.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        
        let d = self.data[indexPath.row]
        if indexPath.row == 0 {
            if let url = privacyLink {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Invalid URL")
            }
        } else if indexPath.row == 1 {
            self.rateApp()
        } else if indexPath.row == 2 {
            self.shareApp()
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedView
    }
}

