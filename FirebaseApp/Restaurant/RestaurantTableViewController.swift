//
//  RestaurantTableViewController.swift
//  RestaurantReservationApp
//
//  Created by Jetarin Taloet ISBC on 9/11/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit
import Foundation
import Firebase

@available(iOS 10.0, *)
class RestaurantTableViewController: UITableViewController{

    var restaurants = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        observeRestaurants()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func observeRestaurants() {
        let restaurantsRef = Database.database().reference().child("restaurants")
        
        restaurantsRef.observe(.value, with: { snapshot in
            var tempRestaurants = [Restaurant]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let restaurantName = dict["restaurantName"] as? String,
                    let restaurantPhoto = dict["restaurantPhoto"] as? String,
                    let restaurantDetail = dict["restaurantDetail"] as? String,
                    let restaurantAddress = dict["restaurantAddress"] as? String,
                    let restaurantPhone = dict["restaurantPhone"] as? String,
                    let restaurantDiagram = dict["restaurantDiagram"] as? String,
                    let openTime = dict["openTime"] as? String,
                    let closeTime = dict["closeTime"] as? String {
                    
                    let restaurants = Restaurant(rid: childSnapshot.key, restaurantName: restaurantName, restaurantPhoto: restaurantPhoto, restaurantDetail: restaurantDetail, restaurantAddress: restaurantAddress, restaurantPhone: restaurantPhone, restaurantDiagram: restaurantDiagram, openTime: openTime, closeTime: closeTime)
                    tempRestaurants.append(restaurants)
                }
            }
            
            self.restaurants = tempRestaurants
            self.tableView.reloadData()
        })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") as! customRestaurantTableViewCell
        let imageURL = URL(string: restaurants[indexPath.row].restaurantPhoto)
        ImageService.getImage(withURL: imageURL!) { image in
            cell.rImage.image = image
        }
        cell.rName.text = restaurants[indexPath.row].restaurantName
        cell.rTime.text = "Open : \(restaurants[indexPath.row].openTime)"
        cell.rTime2.text = "Close : \(restaurants[indexPath.row].closeTime)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurantDetailViewController = storyboard?.instantiateViewController(withIdentifier: "RestaurantDetail") as! RestaurantDetailViewController
        restaurantDetailViewController.data = self.restaurants[indexPath.row]
        navigationController?.pushViewController(restaurantDetailViewController, animated: true)
    }

}
