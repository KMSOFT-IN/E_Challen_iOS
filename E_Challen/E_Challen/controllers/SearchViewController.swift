//
//  SearchViewController.swift
//  E_Challen
//
//  Created by KMSOFT on 21/06/24.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var nodatalebl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var histories:  [History] = []
     var manager = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.navigationController?.isNavigationBarHidden = true
        
        self.nodatalebl.isHidden = true
        self.fetchData()
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
           let okay = UIAlertAction(title: "Okay", style: .default)
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vehicle = histories[indexPath.row]
//                if isValidVehicleNumber(vehicle.vehicle_Number) {
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
