//
//  UserService.swift
//  RestaurantReservationApp
//
//  Created by Jetarin Taloet ISBC on 6/19/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    
    static var currentUserProfile:UserProfile?
    
    static func observeUserProfile(_ uid:String, completion: @escaping ((_ userProfile:UserProfile?)->())) {
        let userRef = Database.database().reference().child("users/\(uid)")
        
        userRef.observe(.value, with: { snapshot in
            var userProfile:UserProfile?
            
            if let dict = snapshot.value as? [String:Any],
                let username = dict["displayName"] as? String,
                let email = dict["email"] as? String,
                let photoURL = dict["photoURL"] as? String,
                let url = URL(string:photoURL) {
                
                userProfile = UserProfile(uid: snapshot.key, username: username, email: email, photoURL: url)
            }
            
            completion(userProfile)
        })
    }
    
}
