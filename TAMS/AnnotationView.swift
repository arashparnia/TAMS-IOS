//
//  AnnotationView.swift
//  TAMS
//
//  Created by arash on 8/24/15.
//  Copyright (c) 2015 arash. All rights reserved.
//

import MapKit
import UIKit
class AnnotationView: NSObject, MKAnnotation {
    let coordinate : CLLocationCoordinate2D
    let title: String?
    let subTitle: String
    let image: UIImage?
    var asset : AssetEntity 
    init(asset : AssetEntity) {
        self.asset = asset
        self.coordinate = CLLocationCoordinate2DMake(asset.latitude, asset.longitude)
        self.title = asset.title
        self.subTitle = "\(coordinate.latitude),\(coordinate.latitude)"
        self.image = UIImage(data:  asset.image!)
        super.init()
    }
    
   
}