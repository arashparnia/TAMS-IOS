//
//  Asset.swift
//  TAMS
//
//  Created by arash on 8/31/15.
//  Copyright (c) 2015 arash. All rights reserved.
//

import Foundation


class Asset : NSObject{
     var date: NSDate = NSDate()
     var latitude: Double = 0.0
     var longitude: Double = 0.0
     var title: String = ""
     var attributes: [AssetAttribute] = []
}