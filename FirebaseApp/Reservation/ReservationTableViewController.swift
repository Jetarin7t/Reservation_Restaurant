//
//  ReservationTableViewController.swift
//  RestaurantReservationApp
//
//  Created by Jetarin Taloet ISBC on 10/7/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class ReservationTableViewController: UITableViewController {
    
    var reservations = [Reservation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeReservations()
        
    }

    func observeReservations() {
        let uid = UserService.currentUserProfile?.uid
        let tablesRef = Database.database().reference().child("reservation")
        
        tablesRef.observe(.value, with: { snapshot in
            var tempReservations = [Reservation]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let key = dict["key"] as? String,
                    let restaurantId = dict["restaurantID"] as? String,
                    let tableId = dict["tableID"] as? String,
                    let tableName = dict["tablename"] as? String,
                    let startTime = dict["start"] as? Int,
                    let endTime = dict["end"] as? Int,
                    let status = dict["status"] as? String,
                    let user = dict["user"] as? String,
                    let userName = dict["username"] as? String {
                    let reserved = Reservation(rid: childSnapshot.key, key: key, restaurantId: restaurantId, tableId: tableId, tableName: tableName, startTime: startTime, endTime: endTime, status: status, user: user, userName: userName)
                    if (uid == reserved.user && reserved.status == "WAIT") {
                        tempReservations.append(reserved)
                    } else {
                        
                    }
                }
            }
            
            self.reservations = tempReservations
            print(self.reservations)
            self.tableView.reloadData()
            
        })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReservation") as! customReservationTableViewCell
        cell.resName.text = "Name : \((UserService.currentUserProfile?.username)!)"
        cell.tableName.text = "Table : \(reservations[indexPath.row].tableName)  Time : \(reservations[indexPath.row].startTime):00"
        cell.tableStatus.text = "Status : \(reservations[indexPath.row].status)"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reservationDetailViewController = storyboard?.instantiateViewController(withIdentifier: "ReservationDetail") as! ReservationDetailViewController
        reservationDetailViewController.dataReserv = reservations[indexPath.row]
        navigationController?.pushViewController(reservationDetailViewController, animated: true)
    }
}
