//
//  RestaurantDiagramViewController.swift
//  RestaurantReservationApp
//
//  Created by Jetarin Taloet ISBC on 9/18/18.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit

class RestaurantDiagramViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var diagramImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageURL = URL(string: diagramImage!)
        ImageService.getImage(withURL: imageURL!) { image in
            self.imageView.image = image
        }
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.contentSize = self.imageView.frame.size
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

}
