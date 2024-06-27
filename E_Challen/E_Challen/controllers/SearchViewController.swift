//
//  SearchViewController.swift
//  E_Challen
//
//  Created by KMSOFT on 21/06/24.
//

import UIKit
import GoogleMobileAds

class SearchViewController: UIViewController, GADFullScreenContentDelegate {

    @IBOutlet weak var nodatalebl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var histories:  [History] = []
    var manager = CoreDataManager()
    var searchCount: Int = 1
    var interstitial: GAMInterstitialAd?
    var adsEnable:Bool = false
    private var isAdLoaded: Bool = false
    var vehicleNumber: String = ""
    var isInternetActive:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.internetReach),
                                               name: Constant.NotificationCenterHelper.INTERNET_REACH,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.internetLost),
                                               name: Constant.NotificationCenterHelper.INTERNET_LOST,
                                               object: nil)
        
        if UserdefaultHelper.getInternet() ?? false {
            self.isInternetActive = true
        }else {
            self.isInternetActive = false
        }
        
        if UserdefaultHelper.getadsEnable() ?? false  && self.isInternetActive {
            self.adsEnable = true
        } else {
            self.adsEnable = false
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.navigationController?.isNavigationBarHidden = true
        
        self.nodatalebl.isHidden = true
        self.fetchData()
        self.setInterstitialAD()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchCount = UserdefaultHelper.getSearchCount() ?? 1
        self.fetchData()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserdefaultHelper.setSearchCount(value: self.searchCount)
    }
    
    
    @objc func internetReach() {
        UserdefaultHelper.setInternet(value: true)
        self.isInternetActive = true
        if UserdefaultHelper.getadsEnable() ?? false && self.isInternetActive {
            self.adsEnable = true
        } else {
            self.adsEnable = false
        }
    }
    
    @objc func internetLost() {
        UserdefaultHelper.setInternet(value: false)
        self.isInternetActive = false
        if UserdefaultHelper.getadsEnable() ?? false && self.isInternetActive {
            self.adsEnable = true
        } else {
            self.adsEnable = false
        }
    }
    
    func fetchData() {
        histories = manager.fetchHistory().sorted(by: { $0.createdAt > $1.createdAt })
          self.tableView.reloadData()
     //   histories = manager.fetchHistory()
    }
    
    static func getInstance() -> SearchViewController {
        return Constant.Storyboard.MAIN.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
    }
    
    @IBAction func backButtontapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func openAlert(message: String) {
           let alertController = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
           let okay = UIAlertAction(title: "Ok", style: .default)
           alertController.addAction(okay)
           present(alertController, animated: true)
       }
    
}

extension SearchViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.histories.count == 0 {
            self.nodatalebl.isHidden = false
        } else {
            self.nodatalebl.isHidden = true
        }
        return self.histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        let history = self.histories[indexPath.row]
        cell.vehicleNumber.text = history.vehicle_Number
        if self.adsEnable {
            cell.adImage.isHidden = true
            
            if self.searchCount >= 3 {
                cell.adImage.isHidden = false
            }
        }else {
            cell.adImage.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vehicle = histories[indexPath.row]
        if self.searchCount >= 3 {
            self.searchCount = 1
            print("^^^ SEARCHVIEW count: \(self.searchCount)")
            self.vehicleNumber = vehicle.vehicle_Number ?? ""
            if self.adsEnable {
                self.loadInertilaAd()
                if isAdLoaded, let interstitial = interstitial {
                    interstitial.present(fromRootViewController: self)
                    isAdLoaded = false // Reset the flag after presenting the ad
                } else {
                    print("Ad wasn't ready")
                    let webViewController = ViewController.getInstance()
                    webViewController.vehicleNumber = vehicle.vehicle_Number
                    self.navigationController?.pushViewController(webViewController, animated: true)
                }
            } else {
                print("Ad wasn't ready")
                let webViewController = ViewController.getInstance()
                webViewController.vehicleNumber = vehicle.vehicle_Number
                self.navigationController?.pushViewController(webViewController, animated: true)
            }
        } else {
            self.searchCount += 1
            print("^^^ SEARCHVIEW count: \(self.searchCount)")
            self.vehicleNumber = vehicle.vehicle_Number ?? ""
            let webViewController = ViewController.getInstance()
            webViewController.vehicleNumber = vehicle.vehicle_Number
            self.navigationController?.pushViewController(webViewController, animated: true)
        }
        
        let historyVehicle = HistoryModel(id: UUID().uuidString,
                                          vehicle_number: vehicle.vehicle_Number,
                                          createdAt: Date().timeIntervalSince1970)
        
        manager.addHistory(historyVehicle)
    }
    
    func isValidVehicleNumber(_ vehicleNumber: String?) -> Bool {
        guard let vehicleNumber = vehicleNumber, !vehicleNumber.isEmpty else {
              return false
          }

          let pattern = "^[a-zA-Z0-9]+$"
          
          let regex = try? NSRegularExpression(pattern: pattern)
          let range = NSRange(location: 0, length: vehicleNumber.utf16.count)
          return regex?.firstMatch(in: vehicleNumber, options: [], range: range) != nil
      }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedView
    }
}


extension SearchViewController {
    func loadWebView() {
        let webViewController = ViewController.getInstance()
         let trimmedText = self.vehicleNumber
       
        let cleanedVehicleNumber = trimmedText.replacingOccurrences(of: " ", with: "")
        let uppercasedVehicleNumber = cleanedVehicleNumber.uppercased()
        webViewController.vehicleNumber = uppercasedVehicleNumber
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
//    ca-app-pub-3940256099942544/4411468910
    func loadInertilaAd() {
        if let interstitial = self.interstitial {
            interstitial.present(fromRootViewController: self)
        }
    }
    
    func setInterstitialAD() {
        let request = GAMRequest()
        GAMInterstitialAd.load(withAdManagerAdUnitID: UserdefaultHelper.getInterstitialId() ?? "" ,
      //  GAMInterstitialAd.load(withAdManagerAdUnitID: "ca-app-pub-3940256099942544/4411468910",
                               request: request,
                               completionHandler: { [weak self] ad, error in
            guard let self = self else { return }
            //            self.activityIndicator.stopAnimating()
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
            self.isAdLoaded = true
        })
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
        self.setInterstitialAD()
        self.loadWebView()
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.setInterstitialAD()
        print("Ad will present full screen content.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      //  self.setInterstitialAD()
        print("Ad did dismiss full screen content.")
        self.loadWebView()
        
    }
    
}
