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
import CoreData

class Assets  {
    static let sharedInstance = Assets()
    var assets = [Asset]()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func addAsset(asset : Asset) {
        let managedObjectContext  = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("AssetsTable",inManagedObjectContext:managedObjectContext!)
        let ass = AssetEntity(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        ass.image = asset.image
        ass.audio = asset.audio
        ass.latitude = asset.latitude
        ass.longitude = asset.longitude
        ass.title = asset.title
        ass.date = asset.date
        ass.attributes.setByAddingObjectsFromArray(asset.attributes as [AnyObject])
    }
    func addAsset(latitude : Double, longitude: Double, title: String) {
        let managedObjectContext  = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("AssetsTable",inManagedObjectContext:managedObjectContext!)
        let ass = AssetEntity(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        //ass.image = NSData()
        //ass.audio = NSData()
        ass.latitude = latitude
        ass.longitude = longitude
        ass.title = title
        ass.date = NSDate()
        //ass.attributes = nil
    }
    
//    func editAsset(location:CLLocation, title: String?=nil,subtitle:String?=nil, Attributes : [AssetAttribute]? = nil ) {
//        //assets[location.description] = Asset(location: location, title: title!, subtitle: subtitle!,Attributes : Attributes!)
//    }
    
//    func removeAsset(location:CLLocation, title: String?=nil,subtitle:String?=nil) {
//        //assets.removeValueForKey(location.description)
//    }
   
    func retriveAllAsets() -> [Asset] {
        var asset  = [Asset]()
        let entityDescription = NSEntityDescription.entityForName("AssetsTable", inManagedObjectContext: managedObjectContext!)
        let request = NSFetchRequest()
        request.entity = entityDescription
        let pred = NSPredicate(value: true)
        request.predicate = pred
        var error: NSError?
        var objects = managedObjectContext?.executeFetchRequest(request,error: &error) as! [AssetEntity]
        for obj in objects{
            let ass : Asset = Asset()
            ass.image = obj.image
            ass.audio = obj.audio
            ass.title = obj.title
            ass.latitude = obj.latitude.doubleValue
            ass.longitude = obj.longitude.doubleValue
            ass.date = obj.date
            for objatt  in obj.attributes {
                let assatt = AssetAttribute()
                assatt.attributeName = (objatt as! AssetAttributeEntity).attributeName
                assatt.attributeData = (objatt as! AssetAttributeEntity).attributeData
            ass.attributes.append(assatt)
            }
            asset.append(ass)
        }
  
        return asset
       
    }
//       func retriveAssetsAtRegin(regin : MKCoordinateRegion )->[Asset]{
//        
//        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//        let entityDescription = NSEntityDescription.entityForName("Assets",inManagedObjectContext: managedObjectContext!)
//        let asset = Asset(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
//        let request = NSFetchRequest()
//        request.entity = entityDescription
//        let pred = NSPredicate(format: "(title = %@)", "John Smith")
//        request.predicate = pred
//        
//        var error: NSError?
//        var results = managedObjectContext?.executeFetchRequest(request, error: &error)
//        
//        let radious = sqrt( pow(regin.span.latitudeDelta,2) + pow(regin.span.longitudeDelta ,2 ))
//        let center = CLLocation(latitude: regin.center.latitude, longitude: regin.center.longitude)
//        var assetsInRegin = [Asset]()
//        //for ass in retriveAllAsets() {
//            //if ass.location.distanceFromLocation(center) < radious {assetsInRegin.append(ass) }
//        //}
//        return assetsInRegin
//    }
    
    func count() -> Int{
        return assets.count
    }
    
}