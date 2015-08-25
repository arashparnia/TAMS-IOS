//
//  Nodes.swift
//  TAMS
//
//  Created by arash on 8/18/15.
//  Copyright (c) 2015 arash. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Assets  {
    static let sharedInstance = Assets()
    var assets = [String:Asset]()

    
    func addAsset(location:CLLocation, title: String?=nil,subtitle:String?=nil) {
        assets[location.description] = Asset(location: location, title: title!, subtitle: subtitle!)
    }
    func editAsset(location:CLLocation, title: String?=nil,subtitle:String?=nil) {
        assets[location.description] = Asset(location: location, title: title!, subtitle: subtitle!)
    }
    func removeAsset(location:CLLocation, title: String?=nil,subtitle:String?=nil) {
        assets.removeValueForKey(location.description)
    }
    func retriveAll() -> AnyObject{
        return self
    }
    func retriveAllAsets() -> [Asset] {
        return(assets.values.array)
    }
    func retriveAllTitles() -> [String] {
        var titles: [String]
        titles = [String]()
        for value in assets.values{
            titles.append(value.title)
        }
        return titles
    }
    func retriveAllKeys() -> [String] {
        var allkeys: [String]
        allkeys = [String]()
        for thekey in assets.keys{
            allkeys.append(thekey)
        }
        return allkeys
    }
    func findAssetWithKey(key:String) -> Asset?{
        println("SEARCHING FOR ",key)
        if let assetvalue = assets[key] { return assetvalue } else { return nil}
    }
    func count() -> Int{
        return assets.count
    }
    
}