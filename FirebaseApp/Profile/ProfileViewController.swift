//
//  ProfileViewController.swift
//  RestaurantReservationApp
//
//  Created by Jetarin Taloet ISBC on 6/19/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var logoutButton: RoundedWhiteButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userphoneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add the background gradient
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        
        guard let userProfile = UserService.currentUserProfile else { return }
        
        ImageService.getImage(withURL: userProfile.photoURL) { image in
            self.profileImageView.image = image
        }
        usernameLabel.text = userProfile.username
        userphoneLabel.text = userProfile.email
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func handleLogout(_ sender: RoundedWhiteButton) {
        try! Auth.auth().signOut()
    }
    
    @IBAction func handleReservation(_ sender: Any) {
        let reservationTableViewController = storyboard?.instantiateViewController(withIdentifier: "ReservationTable") as! ReservationTableViewController
        navigationController?.pushViewController(reservationTableViewController, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }

}
