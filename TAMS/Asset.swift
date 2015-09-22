//
//  Asset.swift
//  TAMS
//
//  Created by arash on 8/31/15.
//  Copyright (c) 2015 arash. All rights reserved.
//

import Foundation
import UIKit

class Asset {
    var image: NSData = UIImageJPEGRepresentation(UIImage(named: "Camera.png")!,2)!
    var audio: NSData = NSData()
    var date: NSDate = NSDate()
    var title: String = ""
    var locations: [Location]=[]
    var attributes: [AssetAttribute] = []
}