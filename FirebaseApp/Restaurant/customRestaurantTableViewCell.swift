//
//  customRestaurantTableViewCell.swift
//  RestaurantReservationApp
//
//  Created by Jetarin Taloet ISBC on 9/11/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit

class customRestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var rImage: UIImageView!
    @IBOutlet weak var rName: UILabel!
    @IBOutlet weak var rTime: UILabel!
    @IBOutlet weak var rTime2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
