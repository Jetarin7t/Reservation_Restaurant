//
//  Table.swift
//  RestaurantReservationApp
//
//  Created by Jetarin Taloet ISBC on 10/5/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import Foundation

class Table {
    var tid:String
    var restaurantId:String
    var tableName:String
    var seat:String
    var openTime:String
    var closeTime:String
    
    init(tid:String, restaurantId:String, tableName:String, seat:String, openTime:String, closeTime:String) {
        self.tid = tid
        self.restaurantId = restaurantId
        self.tableName = tableName
        self.seat = seat
        self.openTime = openTime
        self.closeTime = closeTime
    }
    
}
