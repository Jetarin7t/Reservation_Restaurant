//
//  Promotion.swift
//  RestaurantReservationApp
//
//  Created by Jetarin Taloet ISBC on 6/20/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import Foundation

class Promotion {
    
    var pid:String
    var key:String
    var restaurantId:String
    var photo:String
    var name:String
    var detail:String
    var startDate:String
    var endDate:String
    
    init(pid:String, key:String, restaurantId:String, photo:String, name:String, detail:String, startDate:String, endDate:String) {
        self.pid = pid
        self.key = key
        self.restaurantId = restaurantId
        self.photo = photo
        self.name = name
        self.detail = detail
        self.startDate = startDate
        self.endDate = endDate
    }
    
}
