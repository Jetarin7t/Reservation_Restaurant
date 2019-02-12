//
//  ReservationDetailViewController.swift
//  RestaurantReservationApp
//
//  Created by Jetarin Taloet ISBC on 10/7/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class ReservationDetailViewController: UIViewController {
    
    var dataReserv: Reservation?
    var restaurants = [Restaurant]()

    @IBOutlet weak var resImage: UIImageView!
    @IBOutlet weak var resName: UILabel!
    @IBOutlet weak var tableName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add the background gradient
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        observeRestaurants()
        
        cancelBtn.clipsToBounds = true
        cancelBtn.layer.cornerRadius = 15
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let imageURL = URL(string: restaurants[0].restaurantPhoto)

        ImageService.getImage(withURL: imageURL!) { image in
            self.resImage.image = image
        }
        
        resName.text = restaurants[0].restaurantName
        tableName.text = "Table : \((dataReserv?.tableName)!)"
        time.text = "Time : \((dataReserv?.startTime)!):00"
        status.text = "Status : \((dataReserv?.status)!)"
        userName.text = "Name : \((dataReserv?.userName)!)"
        email.text = "Email : \((UserService.currentUserProfile?.email)!)"
    }
    
    func observeRestaurants() {
        let restaurantsRef = Database.database().reference().child("restaurants")
        
        restaurantsRef.observe(.value, with: { snapshot in
            var tempRestaurants = [Restaurant]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let restaurantName = dict["restaurantName"] as? String,
                    let restaurantPhoto = dict["restaurantPhoto"] as? String,
                    let restaurantDetail = dict["restaurantDetail"] as? String,
                    let restaurantAddress = dict["restaurantAddress"] as? String,
                    let restaurantPhone = dict["restaurantPhone"] as? String,
                    let restaurantDiagram = dict["restaurantDiagram"] as? String,
                    let openTime = dict["openTime"] as? String,
                    let closeTime = dict["closeTime"] as? String {
                    
                    let restaurants = Restaurant(rid: childSnapshot.key, restaurantName: restaurantName, restaurantPhoto: restaurantPhoto, restaurantDetail: restaurantDetail, restaurantAddress: restaurantAddress, restaurantPhone: restaurantPhone, restaurantDiagram: restaurantDiagram, openTime: openTime, closeTime: closeTime)
                    if (restaurants.rid == self.dataReserv?.restaurantId) {
                        tempRestaurants.append(restaurants)
                    }
                }
            }
            
            self.restaurants = tempRestaurants
        })
    }
    
    @IBAction func handleCancel(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm Cancel", message: "Do you want to cancel?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            
            let reservRef = Database.database().reference().child("reservation/\((self.dataReserv?.rid)!)")
            
            reservRef.updateChildValues([
                "status":
                    "CANCEL"
                ])
            
            self.navigationController?.popViewController(animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    

}
