//
//  HomeViewController.swift
//  E_Challen
//
//  Created by KMSOFT on 21/06/24.
//

import UIKit
import GoogleMobileAds

class HomeViewController: UIViewController, UITextFieldDelegate , GADBannerViewDelegate, GADFullScreenContentDelegate{
 
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var noDatalebl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var txtVehicle: UITextField!
    
    private var vehicles:  [Vehicle] = []
    var manager = CoreDataManager()
    var isCheck: Bool = false
    var bannerView: GADBannerView!
    var interstitial: GAMInterstitialAd?
    var searchCount: Int = 1
    private var isAdLoaded: Bool = false
    var adsEnable:Bool = false
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if UserdefaultHelper.getadsEnable() ?? false {
            self.adsEnable = true
        } else {
            self.adsEnable = false
        }
        
        if self.adsEnable {
            
            bannerView = GADBannerView(adSize: GADAdSizeBanner)
            addBannerViewToView(bannerView)
            bannerView.adUnitID = UserdefaultHelper.getBannerId()
            //        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            bannerView.layer.cornerRadius = 8.0
            bannerView.clipsToBounds = true
            bannerView.delegate = self
            
            self.setInterstitialAD()
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
       
        self.noDatalebl.isHidden = true
        
        self.txtVehicle.delegate = self
        self.txtVehicle.autocapitalizationType = .allCharacters
        self.txtVehicle.autocorrectionType = .no
        
        self.fetchData()
        self.navigationController?.isNavigationBarHidden = true
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.adsEnable {
            self.setSearchBUttonUI()
        }
    }
  
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            bannerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0),
            bannerView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            bannerView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -40)
        ])
    }

    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner Ad is Received In Magical View Controller")
    }
    
    func fetchData() {
        vehicles = manager.fetchUsers().sorted(by: { $0.createdAt > $1.createdAt })
          self.tableView.reloadData()
    }
    
    func setSearchBUttonUI() {
        self.searchButton.setTitle("Search", for: .normal)
        
        if self.searchCount >= 3 {
            self.searchButton.setTitle("See ad and Search", for: .normal)
        }
    }
    
    
    static func getInstance() -> HomeViewController {
        return Constant.Storyboard.MAIN.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    }
    
    func loadWebView() {
        let webViewController = ViewController.getInstance()
        let uppercasedVehicleNumber = txtVehicle.text?.uppercased()
        webViewController.vehicleNumber = uppercasedVehicleNumber
        self.navigationController?.pushViewController(webViewController, animated: true)
        self.txtVehicle.text = ""
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
    
    @IBAction func searchButtontapped(_ sender: Any) {
     
        guard let txtVehicle = txtVehicle.text , !txtVehicle.isEmpty else {
            openAlert(message: "Please enter vehicle number.")
            return
        }
        
        print("search count \(self.searchCount)")
        if self.searchCount >= 3 {
            self.searchCount = 1
            let uppercasedVehicleNumber = txtVehicle.uppercased()
            if self.adsEnable {
                self.loadInertilaAd()
                if isAdLoaded, let interstitial = interstitial {
                    interstitial.present(fromRootViewController: self)
                    isAdLoaded = false // Reset the flag after presenting the ad
                } else {
                    print("Ad wasn't ready")
                    let webViewController = ViewController.getInstance()
                    webViewController.vehicleNumber = uppercasedVehicleNumber
                    self.navigationController?.pushViewController(webViewController, animated: true)
                }
            } else {
                self.txtVehicle.text = ""
            }
          
            print("All validations are done!!! good to go...")
            if self.isCheck {
                if manager.vehicleNumberExists(uppercasedVehicleNumber) {
                    let historyVehicle = HistoryModel(id: UUID().uuidString,
                                                      vehicle_number: uppercasedVehicleNumber,
                                                      createdAt: Date().timeIntervalSince1970)
                    
                    manager.addHistory(historyVehicle)
                   // self.txtVehicle.text = ""
                } else {
                    let vehicle = VehicleModel(id: UUID().uuidString,
                                               vehicle_number: uppercasedVehicleNumber,
                                               createdAt: Date().timeIntervalSince1970)
                    manager.addUser(vehicle)
                  //  self.txtVehicle.text = ""
                    self.fetchData()
                    let historyVehicle = HistoryModel(id: UUID().uuidString,
                                                      vehicle_number: uppercasedVehicleNumber,
                                                      createdAt: Date().timeIntervalSince1970)
                    
                    manager.addHistory(historyVehicle)
                }
            }
            else {
                
                let historyVehicle = HistoryModel(id: UUID().uuidString,
                                                  vehicle_number: uppercasedVehicleNumber,
                                                  createdAt: Date().timeIntervalSince1970)
               // self.txtVehicle.text = ""
                manager.addHistory(historyVehicle)
            }
            if self.adsEnable == false {
                let webViewController = ViewController.getInstance()
                webViewController.vehicleNumber = uppercasedVehicleNumber
                self.navigationController?.pushViewController(webViewController, animated: true)
            }
            
        } else {
            self.searchCount += 1
        
            let uppercasedVehicleNumber = txtVehicle.uppercased()
            
            print("All validations are done!!! good to go...")
            if self.isCheck {
                if manager.vehicleNumberExists(uppercasedVehicleNumber) {
                    let historyVehicle = HistoryModel(id: UUID().uuidString,
                                                      vehicle_number: uppercasedVehicleNumber,
                                                      createdAt: Date().timeIntervalSince1970)
                    
                    manager.addHistory(historyVehicle)
                    self.txtVehicle.text = ""
                } else {
                    let vehicle = VehicleModel(id: UUID().uuidString,
                                               vehicle_number: uppercasedVehicleNumber,
                                               createdAt: Date().timeIntervalSince1970)
                    manager.addUser(vehicle)
                    self.txtVehicle.text = ""
                    self.fetchData()
                    let historyVehicle = HistoryModel(id: UUID().uuidString,
                                                      vehicle_number: uppercasedVehicleNumber,
                                                      createdAt: Date().timeIntervalSince1970)
                    
                    manager.addHistory(historyVehicle)
                }
            }
            else {
                
                let historyVehicle = HistoryModel(id: UUID().uuidString,
                                                  vehicle_number: uppercasedVehicleNumber,
                                                  createdAt: Date().timeIntervalSince1970)
                self.txtVehicle.text = ""
                manager.addHistory(historyVehicle)
            }
            
            let webViewController = ViewController.getInstance()
            webViewController.vehicleNumber = uppercasedVehicleNumber
            self.navigationController?.pushViewController(webViewController, animated: true)
        }
    }
    
    @IBAction func historyButtonTapped(_ sender: Any) {
        let vc = SearchViewController.getInstance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func saveButtontapped(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "ic_check") {
              sender.setImage(UIImage(named: "ic_uncheck"), for: .normal)
            self.isCheck = false
          } else {
              sender.setImage(UIImage(named: "ic_check"), for: .normal)
              self.isCheck = true
          }
    }
    
    func openAlert(message: String) {
           let alertController = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
           let okay = UIAlertAction(title: "Okay", style: .default)
           alertController.addAction(okay)
           present(alertController, animated: true)
       }
       
       func showAlert() {
           let alertController = UIAlertController(title: nil, message: "User added", preferredStyle: .alert)
           let okay = UIAlertAction(title: "Okay", style: .default)
           alertController.addAction(okay)
           present(alertController, animated: true)
       }
    
}


extension HomeViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.vehicles.count == 0 {
            self.noDatalebl.isHidden = false
        } else {
            self.noDatalebl.isHidden = true
        }
        return self.vehicles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        let vehicle = self.vehicles[indexPath.row]
        
        cell.vehicleNumber.text = vehicle.vehicle_Number
        
        cell.deleteCallBack = {
            let alert = UIAlertController(title: "Surat E Memo", message: "Are you sure you want to delete this vehicle number?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                self.manager.deleteUser(userEntity: self.vehicles[indexPath.row])
                self.vehicles.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
            alert.addAction(deleteAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vehicle = vehicles[indexPath.row]
               // if isValidVehicleNumber(vehicle.vehicle_Number) {
                    let webViewController = ViewController.getInstance()
                    webViewController.vehicleNumber = vehicle.vehicle_Number
                    self.navigationController?.pushViewController(webViewController, animated: true)
//                } else {
//                    openAlert(message: "Invalid vehicle number.")
//                }
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



struct AdIDs: Codable {
    let adsEnable: Bool
    let androidAppID: String
    let androidBannerID: String
    let androidInterstitialID: String
    let iosAppID: String
    let iosBannerID: String
    let iosInterstitialID: String
    
    enum CodingKeys: String, CodingKey {
        case adsEnable = "adsEnable"
        case androidAppID = "android_app_id"
        case androidBannerID = "android_banner_id"
        case androidInterstitialID = "android_interstitial_id"
        case iosAppID = "ios_app_id"
        case iosBannerID = "ios_banner_id"
        case iosInterstitialID = "ios_interstitial_id"
    }
}
