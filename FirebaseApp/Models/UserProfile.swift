//
//  User.swift
//  RestaurantReservationApp
//
//  Created by Jetarin Taloet ISBC on 6/19/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import Foundation

class UserProfile {
    var uid:String
    var username:String
    var email:String
    var photoURL:URL
    
    init(uid:String, username:String, email:String, photoURL:URL) {
        self.uid = uid
        self.username = username
        self.email = email
        self.photoURL = photoURL
    }
}

