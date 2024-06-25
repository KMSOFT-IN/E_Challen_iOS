//
//  HomeTableViewCell.swift
//  E_Challen
//
//  Created by KMSOFT on 21/06/24.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var vehicleNumber: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var adButton: UIButton!
    @IBOutlet weak var adImage: UIImageView!
    
    var deleteCallBack:(() -> ())?
    var adCallBack:(() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.adImage.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func adButtonTapped(_ sender: Any) {
        self.adCallBack?()
    }
    @IBAction func deleteButtontapped(_ sender: Any) {
        self.deleteCallBack?()
    }
}
