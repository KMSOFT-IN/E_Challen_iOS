//
//  ViewController.swift
//  E_Challen
//
//  Created by KMSOFT on 21/06/24.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var MainView: UIView!
    var vehicleNumber: String?

     private var webView: WKWebView!

     override func viewDidLoad() {
         super.viewDidLoad()

         webView = WKWebView(frame: self.view.frame)
              webView.navigationDelegate = self
              self.MainView.addSubview(webView)

              // Load the initial page
              if let url = URL(string: "https://www.suratcitypolice.org/") {
                  let request = URLRequest(url: url)
                  webView.load(request)
              }
          }

          // WKNavigationDelegate method to know when the page has finished loading
          func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
              let vehicleNumber = vehicleNumber ?? ""

              // JavaScript to set the vehicle number and submit the form
              let js = """
              document.querySelector('input[name="vehicleno"]').value = '\(vehicleNumber)';
              document.querySelector('form').submit();
              """

              // Execute the JavaScript in the web view
              webView.evaluateJavaScript(js) { (result, error) in
                  if let error = error {
                      print("Error: \(error.localizedDescription)")
                  }
              }
          }
     
    @IBAction func backButtontapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
     static func getInstance() -> ViewController {
         return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
     }

}
// Extension to append Data with string
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

