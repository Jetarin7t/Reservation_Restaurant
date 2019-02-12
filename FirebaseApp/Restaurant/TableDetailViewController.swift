//
//  TableDetailViewController.swift
//  RestaurantReservationApp
//
//  Created by Jetarin Taloet ISBC on 10/6/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import UserNotifications

@available(iOS 10.0, *)
class TableDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var seat: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var tableData = [Table]()
    var rName: String?
    var reservations = [Reservation]()
    var pickOption = [Int]()
    
    var open: Int?
    var close: Int?
    var selectTime: Int?
    var endTime: Int?
    var cktime = 0
    var tmpTime = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the background gradient
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        observeReservations()
        
        name.text = "Table Name : \(tableData[0].tableName)"
        seat.text = "Seat Amont : \(tableData[0].seat)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setTime()
    }
    
    func setTime() {
        let str1 = tableData[0].openTime.substring(to: 2)
        let str2 = tableData[0].closeTime.substring(to: 2)
        open = Int(str1)
        close = Int(str2)
        let time1 = open as! Int
        let time2 = close as! Int
        
        for i in time1...time2 {
            pickOption.append(i)
        }
        
        self.tableView.reloadData()
    }
    
    func checkTime() {
        for i in 0..<reservations.count {
            if (reservations[i].tableName == tableData[0].tableName && selectTime == reservations[i].startTime) {
                let alert = UIAlertController(title: "Select Time", message: "Time \(reservations[i].startTime):00 not available", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                self.cktime += 1
            } else {
                
            }
        }
    }
    
    func saveReservation() {
        guard let userProfile = UserService.currentUserProfile else { return }
        
        let reservationRef = Database.database().reference().child("reservation").childByAutoId()
        
        let reservationObject = [
            "key": reservationRef.key,
            "tablename": tableData[0].tableName,
            "tableID": tableData[0].tid,
            "restaurantID": tableData[0].restaurantId,
            "start": selectTime,
            "end": endTime,
            "user": userProfile.uid,
            "username": userProfile.username,
            "status": "WAIT"
            ] as [String : Any]
        
        reservationRef.setValue(reservationObject, withCompletionBlock: { error, ref in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                print(error?.localizedDescription)
            }
        })
        
        let content = UNMutableNotificationContent()
        content.title = "\((rName)!)"
        content.body = "please go to checkin"
        content.sound = UNNotificationSound.default()
        
        var dateInfo = DateComponents()
        dateInfo.hour = selectTime! - 1
        dateInfo.minute = 55
        print("Time Info \(dateInfo)")
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        
        let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    @IBAction func handleReservation(_ sender: Any) {
        checkTime()
        if (cktime == 0) {
            print("put")
            saveReservation()
            
        }
        
        let reservationTableViewController = storyboard?.instantiateViewController(withIdentifier: "ReservationTable") as! ReservationTableViewController
        navigationController?.pushViewController(reservationTableViewController, animated: true)
    }
    
    func observeReservations() {
        let resid = tableData[0].restaurantId
        print(resid)
        let tablesRef = Database.database().reference().child("reservation").queryOrdered(byChild: "restaurantID").queryEqual(toValue: resid)
        
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
                    if (reserved.status != "CANCEL") {
                        tempReservations.append(reserved)
                    } else {
                        
                    }
                }
            }
            
            self.reservations = tempReservations
        })
    }
    
    func checkReservedTime(time: Int) {
        self.tmpTime = 0
        for i in 0..<reservations.count {
            if (reservations[i].tableName == tableData[0].tableName && time == reservations[i].startTime) {
                self.tmpTime = 1
            } else {
                
            }
        }
    }

    // TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickOption.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTable") as! customTableViewCell
        checkReservedTime(time: pickOption[indexPath.row])
        if (self.tmpTime == 1) {
            cell.timeLbl.textColor = UIColor.red
            cell.timeLbl.text = "\(pickOption[indexPath.row]):00 not Available"
        } else {
            cell.timeLbl.text = "\(pickOption[indexPath.row]):00"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkReservedTime(time: pickOption[indexPath.row])
        self.selectTime = pickOption[indexPath.row]
        self.endTime = pickOption[indexPath.row]+1
        if (self.tmpTime == 1) {
            let alert = UIAlertController(title: "Table not Available", message: "Time \(pickOption[indexPath.row]):00 can't reservation", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Confirm Reservtion", message: "Do you want to reservation in \(pickOption[indexPath.row]):00?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
                self.saveReservation()
                let reservationTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "ReservationTable") as! ReservationTableViewController
                self.navigationController?.pushViewController(reservationTableViewController, animated: true)
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}
