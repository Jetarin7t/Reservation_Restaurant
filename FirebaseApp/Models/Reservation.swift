//
//  Reservation.swift
//  RestaurantReservationApp
//
//  Created by Jetarin Taloet ISBC on 10/6/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import Foundation

class Reservation {
    var rid:String
    var key:String
    var restaurantId:String
    var tableId:String
    var tableName:String
    var startTime:Int
    var endTime:Int
    var status:String
    var user:String
    var userName:String
    
    init(rid:String, key:String, restaurantId:String, tableId:String, tableName:String, startTime:Int, endTime:Int, status:String, user:String, userName:String) {
        self.rid = rid
        self.key = key
        self.restaurantId = restaurantId
        self.tableId = tableId
        self.tableName = tableName
        self.startTime = startTime
        self.endTime = endTime
        self.status = status
        self.user = user
        self.userName = userName
    }
    
}
