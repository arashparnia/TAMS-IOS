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

class AssetsController {
    //static let sharedInstance = Assets()
    //var assets = [Asset]()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let animalsFetchRequest = NSFetchRequest(entityName: "AssetEntity")
        let primarySortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let secondarySortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        animalsFetchRequest.sortDescriptors = [primarySortDescriptor, secondarySortDescriptor]
        let frc = NSFetchedResultsController(
            fetchRequest: animalsFetchRequest,
            managedObjectContext: (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!,
            sectionNameKeyPath: nil,
            cacheName: nil)
        //frc.delegate = self
        return frc
        }()
 
    func addAsset(latitude latitude : Double, longitude: Double, title: String){
        let img : UIImage = UIImage(named: "TAMS")!
        
        let assetEntityDescription = NSEntityDescription.entityForName(
            "AssetEntity",inManagedObjectContext:managedObjectContext!)
        let assetentity = AssetEntity(entity: assetEntityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        assetentity.title = title
        assetentity.latitude = latitude
        assetentity.longitude = longitude
        assetentity.date = NSDate()
        assetentity.audio = NSData(contentsOfURL: NSURL.fileURLWithPath(
            NSBundle.mainBundle().pathForResource("55", ofType: "mp3")!))!
        assetentity.image = UIImagePNGRepresentation(img)
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
        
        }
    func addAsset(latitude latitude : Double, longitude: Double, title: String, image: UIImage){

        
        let assetEntityDescription = NSEntityDescription.entityForName(
            "AssetEntity",inManagedObjectContext:managedObjectContext!)
        let assetentity = AssetEntity(entity: assetEntityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        assetentity.title = title
        assetentity.latitude = latitude
        assetentity.longitude = longitude
        assetentity.date = NSDate()
        assetentity.audio = NSData(contentsOfURL: NSURL.fileURLWithPath(
            NSBundle.mainBundle().pathForResource("55", ofType: "mp3")!))!
        assetentity.image = UIImagePNGRepresentation(image)
        addRandomAssetAttributes(9, ass: assetentity)
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
        
    }
    func addRandomAssetAttributes(n :Int,ass:AssetEntity){
        for i in 1...n{
            addAssetAttribute(name:"name \(i)", data: "data \(i)", asset: ass)
        }
    }
    func addAssetAttribute(name name: String,data:String, asset : AssetEntity){
        let attributeEntityDescription = NSEntityDescription.entityForName(
            "AttributeEntity",inManagedObjectContext:managedObjectContext!)
        let attributeEntity = AttributeEntity(entity: attributeEntityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        attributeEntity.attributeName = name
        attributeEntity.attributeData = data
        attributeEntity.asset = asset
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
    }


    func retriveAsset(latitude latitude: Double, longitude: Double) -> AssetEntity? {
        let assetEntityDescription = NSEntityDescription.entityForName("AssetEntity", inManagedObjectContext: managedObjectContext!)
        let request = NSFetchRequest()
        request.entity = assetEntityDescription
        let pred = NSPredicate(format:"abs(latitude - %f) < 0.0001 AND abs(longitude - %f) < 0.0001", latitude, longitude)
        request.predicate = pred
        if let result  = try! managedObjectContext!.executeFetchRequest(request) as? [AssetEntity] {
            return result.first
        } else{
            return nil
        }
    }
    func retriveAsset(latitude latitude: Double, longitude: Double) -> NSFetchedResultsController{
        let request = NSFetchRequest(entityName: "AssetEntity")
        request.predicate = NSPredicate(format:"abs(latitude - %f) < 0.0001 AND abs(longitude - %f) < 0.0001", latitude, longitude)
        let primarySortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let secondarySortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [primarySortDescriptor, secondarySortDescriptor]
        let nsf: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName:nil)
        //print(nsf.description)
        return nsf
    }

    func retriveAllAssets() -> NSFetchedResultsController{
        let request = NSFetchRequest(entityName: "AssetEntity")
        request.predicate = nil
        let primarySortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let secondarySortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [primarySortDescriptor, secondarySortDescriptor]
        let nsf: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName:nil)
        //nsf.fetchedObjects
        //print(nsf.description)
        return nsf
    }
    func retriveAllAttributesForAsset(ass : AssetEntity) -> NSFetchedResultsController{
        let request = NSFetchRequest(entityName: "AttributeEntity")
        let p = NSPredicate(format: "asset == %@",ass)
        request.predicate = p
        let primarySortDescriptor = NSSortDescriptor(key: "attributeName", ascending: true)
        let secondarySortDescriptor = NSSortDescriptor(key: "attributeData", ascending: true)
        request.sortDescriptors = [primarySortDescriptor, secondarySortDescriptor]
        let nsf: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName:nil)
        //nsf.fetchedObjects
        //print(nsf.description)
        return nsf
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
        let entityDescription = NSEntityDescription.entityForName("AssetEntity", inManagedObjectContext: managedObjectContext!)
        let request = NSFetchRequest()
        request.entity = entityDescription
        request.predicate = nil
        let objects = (try! managedObjectContext?.executeFetchRequest(request)) as! [AssetEntity]
        return objects.count
    }
    
        func snapshotForAsset(cord: CLLocationCoordinate2D) -> UIImage?{
            
            let image:UIImage = UIImage()
            let options = MKMapSnapshotOptions()
                if #available(iOS 9.0, *) {
                    let camera = MKMapCamera(lookingAtCenterCoordinate: cord, fromDistance: 500, pitch: 65, heading: 0)
                    options.camera = camera
                    options.size = CGSize(width: 100, height: 100)
                    options.mapType = MKMapType.HybridFlyover
                } else {
                    // Fallback on earlier versions
                }
            
    
            let snap :MKMapSnapshotter  = MKMapSnapshotter(options: options)
            print(snap.loading)
            snap.startWithCompletionHandler {
                (s : MKMapSnapshot? , error : NSError? ) -> Void in
                if (error == nil){
                    print("no error",image.description)
                } else {
                    print("error",error?.description)
                }
            }
    
    
            dispatch_sync(dispatch_get_main_queue(), {return image})
    
            return image
        }
    
    //    func editAsset(location:CLLocation, title: String?=nil,subtitle:String?=nil, Attributes : [AssetAttribute]? = nil ) {
    //        //assets[location.description] = Asset(location: location, title: title!, subtitle: subtitle!,Attributes : Attributes!)
    //    }
    
    //    func removeAsset(location:CLLocation, title: String?=nil,subtitle:String?=nil) {
    //        //assets.removeValueForKey(location.description)
    //    }

}