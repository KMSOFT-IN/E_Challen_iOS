//
//  HomeViewController.swift
//  E_Challen
//
//  Created by KMSOFT on 21/06/24.
//

import UIKit

class HomeViewController: UIViewController {

    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var txtVehicle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
       
    }
    
    static func getInstance() -> HomeViewController {
        return Constant.Storyboard.MAIN.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    }
    
    @IBAction func searchButtontapped(_ sender: Any) {
        let vc = SearchViewController.getInstance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func clockButtontapped(_ sender: Any) {
    }
    
    @IBAction func saveButtontapped(_ sender: UIButton) {
     //   if isCompleteChecked == false {
            //saveButton.setImage(UIImage(named: "ic_check"), for: .normal)
    //isCompleteChecked = true
         
      //  }
        
        if sender.currentImage == UIImage(named: "ic_check") {
              sender.setImage(UIImage(named: "ic_uncheck"), for: .normal)
              // Perform actions for unchecked state if needed
          } else {
              sender.setImage(UIImage(named: "ic_check"), for: .normal)
              // Perform actions for checked state if needed
          }
    }
    
}


extension HomeViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedView
    }
}
