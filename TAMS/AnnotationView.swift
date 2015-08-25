//
//  AnnotationView.swift
//  TAMS
//
//  Created by arash on 8/24/15.
//  Copyright (c) 2015 arash. All rights reserved.
//

import MapKit

class AnnotationView: NSObject, MKAnnotation {
    let title: String
    let subTitle: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, subTitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subTitle = subTitle
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String {
        return subTitle
    }
}