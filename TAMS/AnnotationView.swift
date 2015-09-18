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
    let title: String?
    let subTitle: String
    let coordinate: CLLocationCoordinate2D
    let imagedata : NSData
    var asset = Asset()
    
    init(asset : Asset) {
        self.title = asset.title
        self.subTitle = "\(asset.latitude),\(asset.longitude)"
        self.coordinate = CLLocationCoordinate2D(latitude: asset.latitude, longitude: asset.longitude)
        self.imagedata = asset.image
        self.asset = asset
        super.init()
    }
   
}