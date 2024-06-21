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
    
    var deleteCallBack:(() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteButtontapped(_ sender: Any) {
        self.deleteCallBack?()
    }
}
