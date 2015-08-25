//
//  AssetViewController.swift
//  TAMS
//
//  Created by arash on 8/23/15.
//  Copyright (c) 2015 arash. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AssetViewController: UIViewController{
   
    var theTitle : String  = ""
    var theLocation : CLLocation = CLLocation(latitude: 0, longitude: 0)
    var thelocationdescription : Double = 0.0
   
    @IBOutlet weak var smallMap: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var assetTitleLabel: UILabel!
   
    
   
    override func viewDidLoad() {
    
        var rightSaveBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveTapped:")
        self.navigationItem.setRightBarButtonItems([rightSaveBarButtonItem], animated: true)
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = theLocation.coordinate
        annotation.title = theTitle
        annotation.subtitle = theLocation.description
        smallMap.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.001, 0.001)
        let region = MKCoordinateRegion(center: theLocation.coordinate, span: span)
        smallMap.setRegion(region, animated: true)
        smallMap.showsBuildings = true
        
        assetTitleLabel.text = theTitle
        locationLabel.text = theLocation.description
        
    }
    func saveTapped(sender:UIButton) {
        println("search pressed")
    }
 
}