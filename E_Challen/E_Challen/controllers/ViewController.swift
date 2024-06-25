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
    private var loadingIndicator: UIActivityIndicatorView!
    private var formSubmitted = false
    private let monitor = NWPathMonitor()
    
    override func viewDidLoad() {
          super.viewDidLoad()

          webView = WKWebView(frame: self.view.frame)
               webView.navigationDelegate = self
               self.MainView.addSubview(webView)

        loadingIndicator = UIActivityIndicatorView(style: .large)
                loadingIndicator.center = self.view.center
                self.view.addSubview(loadingIndicator)
        
        monitorNetwork()
        
               // Load the initial page
//               if let url = URL(string: "https://www.suratcitypolice.org/") {
//                   let request = URLRequest(url: url)
//                   webView.load(request)
//               }
           }
    
    private func monitorNetwork() {
            monitor.pathUpdateHandler = { path in
                DispatchQueue.main.async {
                    if path.status == .satisfied {
                        self.loadWebPage()
                        UserdefaultHelper.setInternet(value: <#T##Bool?#>)
                    } else {
                        self.loadingIndicator.stopAnimating()
                        self.showNoInternetConnectionScreen()
                    }
                }
            }
            
            let queue = DispatchQueue(label: "NetworkMonitor")
            monitor.start(queue: queue)
        }
    
    private func loadWebPage() {
            if let url = URL(string: "https://www.suratcitypolice.org/") {
                let request = URLRequest(url: url)
                webView.load(request)
                loadingIndicator.startAnimating()
            }
        }
        
        private func showNoInternetConnectionScreen() {
            let html = """
            <html>
            <head>
            <title>No Internet Connection</title>
            <style>
            body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
            h1 { font-size: 48px; color: #333; }
            p { font-size: 18px; color: #666; }
            </style>
            </head>
            <body>
            <h1>No Internet Connection</h1>
            <p>Please check your internet connection and try again.</p>
            </body>
            </html>
            """
            webView.loadHTMLString(html, baseURL: nil)
        }
        
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
                } else {
                    self.loadingIndicator.stopAnimating()
                    self.webView.isHidden = false
                }
            }
        }

           // WKNavigationDelegate method to know when the page has finished loading
//           func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//               let vehicleNumber = vehicleNumber ?? ""
//
//               // JavaScript to set the vehicle number and submit the form
//               let js = """
//               document.querySelector('input[name="vehicleno"]').value = '\(vehicleNumber)';
//               document.querySelector('form').submit();
//               """
//
//               // Execute the JavaScript in the web view
//               webView.evaluateJavaScript(js) { (result, error) in
//                   if let error = error {
//                       print("Error: \(error.localizedDescription)")
//                   }
//               }
//           }
    
    //----------------------
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        webView = WKWebView(frame: self.view.frame)
//        webView.navigationDelegate = self
//        
//       // webView.isHidden = true
//        self.MainView.addSubview(webView)
//        
////        loadingIndicator = UIActivityIndicatorView(style: .large)
////        loadingIndicator.center = self.view.center
////        loadingIndicator.startAnimating()
////        self.view.addSubview(loadingIndicator)
//        
//        if let url = URL(string: "https://www.suratcitypolice.org/") {
//            let request = URLRequest(url: url)
//            webView.load(request)
//        }
//    }
    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        if webView.url?.absoluteString == "https://www.suratcitypolice.org/" && !formSubmitted {
//            guard let vehicleNumber = vehicleNumber else {
//                print("Vehicle number is nil")
//                return
//            }
//            
//            let js = """
//                               document.querySelector('input[name="vehicleno"]').value = '\(vehicleNumber)';
//                               document.querySelector('form').submit();
//                               """
//            webView.evaluateJavaScript(js) { (result, error) in
//                if let error = error {
//                    print("Error: \(error.localizedDescription)")
//                } else {
//                    self.formSubmitted = true
//                }
//            }
//        } else if let url = webView.url?.absoluteString {
//            if url.contains("/home/search") {
//                webView.evaluateJavaScript("document.body.innerText") { (result, error) in
//                    if let error = error {
//                        print("Error: \(error.localizedDescription)")
//                        return
//                    }
//                    
//                    guard let bodyText = result as? String else {
//                        return
//                    }
//                    
//                    if bodyText.contains("No records found") {
////                        self.loadingIndicator.stopAnimating()
//                        self.webView.isHidden = false
//                    } else {
////                        self.loadingIndicator.stopAnimating()
//                        self.webView.isHidden = false
//                    }
//                }
//            } else {
////                self.loadingIndicator.stopAnimating()
//                self.webView.isHidden = false
//            }
//        }
//    }
    
    // WKNavigationDelegate method to know when the page has finished loading
    //          func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    //              let vehicleNumber = vehicleNumber ?? ""
    //
    //              // JavaScript to set the vehicle number and submit the form
    //              let js = """
    //              document.querySelector('input[name="vehicleno"]').value = '\(vehicleNumber)';
    //              document.querySelector('form').submit();
    //              """
    //
    //              // Execute the JavaScript in the web view
    //              webView.evaluateJavaScript(js) { (result, error) in
    //                  if let error = error {
    //                      print("Error: \(error.localizedDescription)")
    //                  }
    //              }
    //          }
    
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

