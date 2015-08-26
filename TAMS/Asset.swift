//
//  Nodes.swift
//  TAMS
//
//  Created by arash on 8/17/15.
//  Copyright (c) 2015 arash. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Asset : NSObject{
 
    var location : CLLocation =  CLLocation(latitude: 38.560884, longitude: -121.422357)
    var title  = "Riverside"
    var subtitle = ""
    var image : UIImage = UIImage(named: "stopsign.jpeg")!
    
    init(location : CLLocation){
        self.location = location
    }
    init(location : CLLocation,title : String){
        self.location = location
        self.title = title
    }
    init(location : CLLocation,title : String,subtitle : String){
        self.location = location
        self.title = title
        self.subtitle = subtitle
    }
    
 
   
}