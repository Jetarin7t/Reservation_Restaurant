//
//  customTableViewCell.swift
//  RestaurantReservationApp
//
//  Created by Jetarin Taloet ISBC on 10/9/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit

class customTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
