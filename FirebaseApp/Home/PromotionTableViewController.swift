//
//  PromotionTableViewController.swift
//  RestaurantReservationApp
//
//  Created by Jetarin Taloet ISBC on 10/2/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import UserNotifications

@available(iOS 10.0, *)
class PromotionTableViewController: UITableViewController {
    
    var promotions = [Promotion]()
    var countPromotion = 0
    
    static var notiPromo = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    
        self.observePromotions()
    }
    
    func observePromotions() {
        
        let promotionsRef = Database.database().reference().child("promotions")
        
        promotionsRef.observe(.value, with: { snapshot in
            
            var tempPromotions = [Promotion]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let key = dict["key"] as? String,
                    let restaurantId = dict["restaurantID"] as? String,
                    let photo = dict["photo"] as? String,
                    let name = dict["name"] as? String,
                    let detail = dict["detail"] as? String,
                    let startDate = dict["startDate"] as? String,
                    let endDate = dict["endDate"] as? String {
                    
                    let promotions = Promotion(pid: childSnapshot.key, key: key, restaurantId: restaurantId, photo: photo, name: name, detail: detail, startDate: startDate, endDate: endDate)
                    tempPromotions.append(promotions)
                    self.countPromotion+=1
                }
            }
            
            self.promotions = tempPromotions
            self.tableView.reloadData()
            
            if PromotionTableViewController.notiPromo == 0 {
                self.setNotiPromotion()
                PromotionTableViewController.notiPromo+=1
            }
            
        })
    }
    
    func setNotiPromotion() {
        let content = UNMutableNotificationContent()
        content.title = "New Promotion"
        content.body = "\(promotions[self.countPromotion-1].name)"
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promotions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPromotion") as! customPromotionTableViewCell
        let imageURL = URL(string: promotions[indexPath.row].photo)
        ImageService.getImage(withURL: imageURL!) { image in
            cell.proImage.image = image
        }
        cell.proDate.text = "\(promotions[indexPath.row].startDate) to \(promotions[indexPath.row].endDate)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let promotionDetailViewController = storyboard?.instantiateViewController(withIdentifier: "PromotionDetail") as! PromotionDetailViewController
        promotionDetailViewController.data = self.promotions[indexPath.row]
        navigationController?.pushViewController(promotionDetailViewController, animated: true)
    }

}
