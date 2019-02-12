//
//  TableViewController.swift
//  RestaurantReservationApp
//
//  Created by Jetarin Taloet ISBC on 10/5/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit
import Foundation
import Firebase

@available(iOS 10.0, *)
class TableViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewDiagram: UIButton!
    
    
    var tables = [Table]()
    var resid: String?
    var resname: String?
    var resdiagram: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        observeTables()
        
        viewDiagram.clipsToBounds = true
        viewDiagram.layer.cornerRadius = 15
        
    }
    
    @IBAction func handleDiagram(_ sender: Any) {
        let restaurantDiagramController = storyboard?.instantiateViewController(withIdentifier: "RestaurantDiagram") as! RestaurantDiagramViewController
        restaurantDiagramController.diagramImage = (resdiagram)!
        navigationController?.pushViewController(restaurantDiagramController, animated: true)
    }
    
    func observeTables() {
        let tablesRef = Database.database().reference().child("tables").queryOrdered(byChild: "restaurantID").queryEqual(toValue: self.resid)

        tablesRef.observe(.value, with: { snapshot in
            var tempTables = [Table]()

            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let restaurantId = dict["restaurantID"] as? String,
                    let tableName = dict["tablename"] as? String,
                    let seat = dict["seat"] as? String,
                    let tableOpen = dict["tableopen"] as? String,
                    let tableClose = dict["tableclose"] as? String {
                    let tables = Table(tid: childSnapshot.key, restaurantId: restaurantId, tableName: tableName, seat: seat, openTime: tableOpen, closeTime: tableClose)
                    tempTables.append(tables)
                }
            }

            self.tables = tempTables
            self.collectionView.reloadData()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tables.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = self.tables[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TableCollectionViewCell
        cell.tableName.text = "\(data.tableName)"
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.tables[indexPath.row]
        let tableDetailController = storyboard?.instantiateViewController(withIdentifier: "TableDetail") as! TableDetailViewController
        tableDetailController.tableData = [data]
        tableDetailController.rName = resname
        navigationController?.pushViewController(tableDetailController, animated: true)
    }
}
