//
//  HomeViewController.swift
//  E_Challen
//
//  Created by KMSOFT on 21/06/24.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
 
    @IBOutlet weak var noDatalebl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var txtVehicle: UITextField!
    
    private var vehicles:  [Vehicle] = []
    var manager = CoreDataManager()
    var isCheck: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
       
    }
    
    func fetchData() {
        vehicles = manager.fetchUsers()
        self.tableView.reloadData()
    }
    
    static func getInstance() -> HomeViewController {
        return Constant.Storyboard.MAIN.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    }
    
    @IBAction func searchButtontapped(_ sender: Any) {
        guard let txtVehicle = txtVehicle.text , !txtVehicle.isEmpty else {
            openAlert(message: "Please enter vehicle number.")
            return
        }
        
        let uppercasedVehicleNumber = txtVehicle.uppercased()
        
        print("All validations are done!!! good to go...")
        if self.isCheck {
            if manager.vehicleNumberExists(uppercasedVehicleNumber) {
               // openAlert(message: "Vehicle number already exists.")
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
            
            manager.addHistory(historyVehicle)
        }
        
       // if isValidVehicleNumber(txtVehicle) {
            let webViewController = ViewController.getInstance()
            webViewController.vehicleNumber = uppercasedVehicleNumber
            self.navigationController?.pushViewController(webViewController, animated: true)
//        } else {
//            openAlert(message: "Invalid vehicle number.")
//        }
      //O  navigationController?.popViewController(animated: true)
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
