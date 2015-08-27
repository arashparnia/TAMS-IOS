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

    
    func addAsset(location:CLLocation, title: String?=nil,subtitle:String?=nil , categories: [Assetcategory]? = nil) {
        assets[location.description] = Asset(location: location, title: title!, subtitle: subtitle!,categories : categories!)
    }
    func editAsset(location:CLLocation, title: String?=nil,subtitle:String?=nil, categories : [Assetcategory]? = nil ) {
        assets[location.description] = Asset(location: location, title: title!, subtitle: subtitle!,categories : categories!)
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
    func retriveAssetsAtRegin(regin : MKCoordinateRegion )->[Asset]{
        let radious = sqrt( pow(regin.span.latitudeDelta,2) + pow(regin.span.longitudeDelta ,2 ))
        let center = CLLocation(latitude: regin.center.latitude, longitude: regin.center.longitude)
        var assetsInRegin = [Asset]()
        for ass in retriveAllAsets() {
            if ass.location.distanceFromLocation(center) < radious {assetsInRegin.append(ass) }
        }
        return assetsInRegin
    }
    func findAssetWithKey(key:String) -> Asset?{
        println("SEARCHING FOR ",key)
        if let assetvalue = assets[key] { return assetvalue } else { return nil}
    }
    func count() -> Int{
        return assets.count
    }
    
}