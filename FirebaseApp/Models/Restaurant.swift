//
//  Restaurant.swift
//  RestaurantReservationApp
//
//  Created by Jetarin Taloet ISBC on 9/11/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import Foundation

class Restaurant {
    var rid:String
    var restaurantName:String
    var restaurantPhoto:String
    var restaurantDetail:String
    var restaurantAddress:String
    var restaurantPhone:String
    var restaurantDiagram:String
    var openTime:String
    var closeTime:String
    
    init(rid:String, restaurantName:String, restaurantPhoto:String, restaurantDetail:String, restaurantAddress:String, restaurantPhone:String, restaurantDiagram:String, openTime:String, closeTime:String) {
        self.rid = rid
        self.restaurantName = restaurantName
        self.restaurantPhoto = restaurantPhoto
        self.restaurantDetail = restaurantDetail
        self.restaurantAddress = restaurantAddress
        self.restaurantPhone = restaurantPhone
        self.restaurantDiagram = restaurantDiagram
        self.openTime = openTime
        self.closeTime = closeTime
    }
    
}
