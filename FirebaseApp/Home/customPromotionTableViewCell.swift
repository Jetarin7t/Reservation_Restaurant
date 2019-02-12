//
//  customPromotionTableViewCell.swift
//  RestaurantReservationApp
//
//  Created by Jetarin Taloet ISBC on 10/2/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit

class customPromotionTableViewCell: UITableViewCell {

    @IBOutlet weak var proImage: UIImageView!
    @IBOutlet weak var proDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
