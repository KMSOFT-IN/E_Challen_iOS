//
//  SearchTableViewCell.swift
//  E_Challen
//
//  Created by KMSOFT on 21/06/24.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var adImage: UIImageView!
    @IBOutlet weak var adButton: UIButton!
    @IBOutlet weak var vehicleNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.adImage.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func adButtontapped(_ sender: Any) {
    }
}
