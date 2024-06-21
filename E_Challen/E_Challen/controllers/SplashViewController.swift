//
//  SplashViewController.swift
//  E_Challen
//
//  Created by KMSOFT on 21/06/24.
//

import UIKit

class SplashViewController: UIViewController {

    
    
    @IBOutlet weak var continueBtton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    static func getInstance() -> SplashViewController {
        return Constant.Storyboard.MAIN.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
    }
    
    @IBAction func continueButtontapped(_ sender: Any) {
        let vc = HomeViewController.getInstance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
