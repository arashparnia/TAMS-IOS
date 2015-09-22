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
    
 
    func addAsset(latitude latitude : Double, longitude: Double, title: String) -> Asset?{
        let img : UIImage = UIImage(named: "TAMS")!
        let loc = Location(latitude: latitude, longitude: longitude)
        let ass : Asset = Asset()
        ass.title = title
        ass.date = NSDate()
        ass.locations.append(loc)
        ass.audio = NSData(contentsOfURL: NSURL.fileURLWithPath(
            NSBundle.mainBundle().pathForResource("55", ofType: "mp3")!))!
        ass.image = UIImagePNGRepresentation(img)!
        
        
        let managedObjectContext  = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let assetTableEntityDescription = NSEntityDescription.entityForName("AssetsTable",inManagedObjectContext:managedObjectContext!)
        let assetentity = AssetEntity(entity: assetTableEntityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        let locationTableEntityDescription = NSEntityDescription.entityForName("Location",inManagedObjectContext:managedObjectContext!)
        let locationentity = LocationEntity(entity: locationTableEntityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        locationentity.latitude = latitude
        locationentity.longitude = longitude
        locationentity.asset = assetentity
        
        assetentity.title = title
        assetentity.date = NSDate()
        assetentity.audio = ass.audio
        assetentity.image = UIImagePNGRepresentation(img)
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
        
        return ass
        }

   
    func retriveAllAsets() -> [Asset] {
        var asset  = [Asset]()
        let entityDescription = NSEntityDescription.entityForName("AssetsTable", inManagedObjectContext: managedObjectContext!)
        let request = NSFetchRequest()
        request.entity = entityDescription
        request.predicate = nil
        
        let objects = (try! managedObjectContext?.executeFetchRequest(request)) as! [AssetEntity]
        for obj in objects{
            let ass : Asset = Asset()
            if let img = obj.image {ass.image = img}
            if let aud = obj.audio {ass.audio = aud}
            ass.title = obj.title
            ass.date = obj.date
            if let att = obj.attributes{
            for objatt  in att {
                let assatt = AssetAttribute()
                assatt.attributeName = (objatt as! AssetAttributeEntity).attributeName!
                assatt.attributeData = (objatt as! AssetAttributeEntity).attributeData!
                ass.attributes.append(assatt)
                }
            }
            for objloc in obj.location {
                if let loc = objloc as? LocationEntity{
                    let assloc = Location(latitude: loc.latitude, longitude: loc.longitude)
                    ass.locations.append(assloc)
                }
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
    
    //    func snapshotForAsset(cord: CLLocationCoordinate2D) -> UIImage?{
    //        let image:UIImage = UIImage()
    //        let options = MKMapSnapshotOptions()
    //        if #available(iOS 9.0, *) {
    //            options.mapType = MKMapType.HybridFlyover
    //            let camera = MKMapCamera(lookingAtCenterCoordinate: cord, fromDistance: 500, pitch: 65, heading: 0)
    //            options.camera = camera
    //        } else {
    //            options.mapType = MKMapType.Hybrid
    //            options.scale = 2
    //            options.mapType = MKMapType.Standard
    //            options.region = MKCoordinateRegionMake(cord, MKCoordinateSpanMake(0.5, 0.5))
    //        }
    //        options.size = CGSize(width: 100, height: 100)
    //
    //        let snap :MKMapSnapshotter  = MKMapSnapshotter(options: options)
    //        print(snap.loading)
    //        snap.startWithCompletionHandler {
    //            (s : MKMapSnapshot? , error : NSError? ) -> Void in
    //            if (error == nil){
    //                print("no error",image.description)
    //            } else {
    //                print("error",error?.description)
    //            }
    //        }
    //
    //
    //        dispatch_sync(dispatch_get_main_queue(), {return image})
    //
    //        return image
    //    }
    
    //    func editAsset(location:CLLocation, title: String?=nil,subtitle:String?=nil, Attributes : [AssetAttribute]? = nil ) {
    //        //assets[location.description] = Asset(location: location, title: title!, subtitle: subtitle!,Attributes : Attributes!)
    //    }
    
    //    func removeAsset(location:CLLocation, title: String?=nil,subtitle:String?=nil) {
    //        //assets.removeValueForKey(location.description)
    //    }

}