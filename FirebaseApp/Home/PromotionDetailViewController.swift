//
//  PromotionDetailViewController.swift
//  RestaurantReservationApp
//
//  Created by Jetarin Taloet ISBC on 10/4/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit

class PromotionDetailViewController: UIViewController {

    @IBOutlet weak var proImage: UIImageView!
    @IBOutlet weak var proName: UILabel!
    @IBOutlet weak var proDetail: UILabel!
    @IBOutlet weak var proDate: UILabel!
    
    var data: Promotion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageURL = URL(string: (data?.photo)!)
        ImageService.getImage(withURL: imageURL!) { image in
            self.proImage.image = image
        }
        
        proName.text = (data?.name)!
        proDetail.text = (data?.detail)!
        proDate.text = "\((data?.startDate)!) to \((data?.endDate)!)"
        
    }
    

}
