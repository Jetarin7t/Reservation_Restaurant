//
//  RestaurantDetailViewController.swift
//  RestaurantReservationApp
//
//  Created by Jetarin Taloet ISBC on 9/12/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class RestaurantDetailViewController: UIViewController {
    
    @IBOutlet weak var restuarantImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var tableButton: UIButton!
    
    var data: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the background gradient
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        let imageURL = URL(string: (data?.restaurantPhoto)!)
        ImageService.getImage(withURL: imageURL!) { image in
            self.restuarantImage.image = image
        }
        nameLbl.text = (data?.restaurantName)!
        timeLbl.text = "Open \((data?.openTime)!) - \((data?.closeTime)!)"
        detailLbl.text = (data?.restaurantDetail)!
        phoneLbl.text = "Tel. \((data?.restaurantPhone)!)"
    }
    
    @IBAction func tableTap(_ sender: UIButton) {
        let tableViewController = storyboard?.instantiateViewController(withIdentifier: "RestaurantTable") as! TableViewController
        tableViewController.resid = "\((data?.rid)!)"
        tableViewController.resname = "\((data?.restaurantName)!)"
        tableViewController.resdiagram = "\((data?.restaurantDiagram)!)"
        navigationController?.pushViewController(tableViewController, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
