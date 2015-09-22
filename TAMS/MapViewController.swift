//
//  ViewController.swift
//  TAMS
//
//  Created by arash on 8/16/15.
//  Copyright (c) 2015 arash. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import ImageIO
import AVFoundation


class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate {
 @IBOutlet weak var MapView: MKMapView!
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let centerLocation = CLLocationCoordinate2D(
        latitude : 38.560884,
        longitude : -121.422357
    )
    let radious = 0.1
    var locations : [CLLocationCoordinate2D]=[]
    var annotations:[AnnotationView] = []
    let clusteringManager = FBClusteringManager()
    
   
    // random generator
 
    override func viewDidLoad() {
      
        MapView.delegate = self
        removeAnnotations()
        makeAnnotationsFromAssets()
    
        // gesture and bottons setup
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 1.0
        MapView.addGestureRecognizer(uilpgr)
        uilpgr.delegate = self
        
        let rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "LIST", style: UIBarButtonItemStyle.Plain, target: self, action: "listTapped:")
        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "searchTapped:")
        self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem,rightSearchBarButtonItem], animated: true)
        
    
        
        addRandomAssetToMap()
        
        //add annotations to map
        MapView.addAnnotations(annotations)
        MapView.showAnnotations(annotations, animated: true)
      
        //let span = MKCoordinateSpanMake(radious, radious)
        //let region = MKCoordinateRegion(center: centerLocation, span: span)
        //MapView.setRegion(region, animated: true)
        
        // add annotation cluster control
        clusteringManager.addAnnotations(annotations)
        
      
        
        //POLY LINE
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.001, longitude: -121.422357 + 0.001))
        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.002, longitude: -121.422357 + 0.001))
        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.001, longitude: -121.422357 + 0.002))
        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.003, longitude: -121.422357 + 0.003))
        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.005, longitude: -121.422357 + 0.003))
        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.003, longitude: -121.422357 + 0.006))
        points.append(CLLocationCoordinate2D(latitude: 38.560884 - 0.003, longitude: -121.422357 - 0.003))
        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.001, longitude: -121.422357 + 0.001))
        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.002, longitude: -121.422357 + 0.001))
        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.001, longitude: -121.422357 + 0.002))
        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.003, longitude: -121.422357 + 0.003))
        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.005, longitude: -121.422357 + 0.003))
        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.003, longitude: -121.422357 + 0.006))
        let polyline =  MKPolyline(coordinates: &points, count: points.count)
        MapView.addOverlay(polyline)
        MapView.showsBuildings = true
        MapView.showsUserLocation = false
        
        
        super.viewDidLoad()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //let location = CLLocationCoordinate2DMake(48.85815,2.29452)
        if #available(iOS 9.0, *) {
            MapView.mapType = .HybridFlyover
            MapView.showsScale = true
            let camera = MKMapCamera(lookingAtCenterCoordinate: centerLocation, fromDistance: 200, pitch: 65, heading: 0)
            MapView.setCamera(camera, animated: true)
        } else {
            // Fallback on earlier versions
            MapView.mapType = .Standard
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func mapType(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            MapView.mapType = MKMapType.Standard
            MapView.removeAnnotations(annotations)
            MapView.addAnnotations(annotations)
        } else {
            if #available(iOS 9.0, *) {
                MapView.mapType = .HybridFlyover
            } else {
                // Fallback on earlier versions
                MapView.mapType = .Hybrid
            }
            MapView.removeAnnotations(annotations)
            MapView.addAnnotations(annotations)
        }
    }
    
  
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var reuseId = ""
        if annotation.isKindOfClass(FBAnnotationCluster) {
            reuseId = "Cluster"
            var clusterView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId)
            return clusterView
        } else {
            let annotation = annotation as? AnnotationView
            var view: MKPinAnnotationView
            let identifier = "pin"
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            let theimage = UIImage(data:annotation!.imagedata)
            let size = CGSizeApplyAffineTransform(theimage!.size, CGAffineTransformMakeScale(0.5, 0.5))
            let hasAlpha = false
            let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
            UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
            theimage!.drawInRect(CGRect(origin: CGPointZero, size: size))
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            view.image = scaledImage
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: 0, y: 0)
            view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            return view
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let v = view.annotation as! AnnotationView
        performSegueWithIdentifier("MapToAssetView", sender: v)
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        NSOperationQueue().addOperationWithBlock({
            let mapBoundsWidth = Double(self.MapView.bounds.size.width)
            let mapRectWidth:Double = self.MapView.visibleMapRect.size.width
            let scale:Double = mapBoundsWidth / mapRectWidth
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(self.MapView.visibleMapRect, withZoomScale:scale)
            self.clusteringManager.displayAnnotations(annotationArray, onMapView:self.MapView)
        })
    }
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    }
    
    //MARK:- MapViewDelegate methods
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 5
            return polylineRenderer
    }
    
    func action(gestureRecognizer:UIGestureRecognizer) {
        print("long press detected ")
        let touchPoint = gestureRecognizer.locationInView(self.MapView)
        let newCoordinate:CLLocationCoordinate2D = MapView.convertPoint(touchPoint, toCoordinateFromView: self.MapView)
      
        let ass = Asset()
        let ann = AnnotationView(asset: ass)
        MapView.addAnnotation(ann)
        MapView.showAnnotations([ann], animated: true)
        Assets.sharedInstance.addAsset(latitude:newCoordinate.latitude, longitude: newCoordinate.longitude, title: "NEW ASSET")
        performSegueWithIdentifier("MapToAssetView", sender: ann)
    }

    
    func searchTapped(sender:UIButton) {
        print("search pressed")
        for i in 0...10{
            print("adding asset:\(i)")
            addRandomAssetToMap()
        }
        clusteringManager.addAnnotations(annotations)
        MapView.addAnnotations(annotations)
        MapView.showAnnotations(annotations, animated: true)
    }
    
    func listTapped (sender:UIButton) {
        print("list pressed")
        performSegueWithIdentifier("TableView", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MapToAssetView"{
            let assetVC = segue.destinationViewController as! AssetViewController
            assetVC.asset = (sender as! AnnotationView).asset
        } else if segue.identifier == "TableView"{
            _ = segue.destinationViewController as! TableViewController
        }
    }
    
    
    
    
    func makeRand(latlong: String) -> Double{
        //Latitude: -85 to +85 (actually -85.05115 for some reason)
        //Longitude: -180 to +180
        var r : Double = 0
        if (latlong == "latitude") {
            
            let upper : UInt32 = 85*2
            r = (Double(upper)/2) - Double(arc4random_uniform(upper))
        } else if (latlong == "longitude"){
            
            let upper : UInt32 = 180*2
            r = (Double(upper)/2) - Double(arc4random_uniform(upper))
        }
        let randomfloat = CGFloat( (Float(arc4random()) / Float(UINT32_MAX)) )
        r = r + Double(randomfloat)
        r=r/1000
        print(r)
        return r
    }
    func removeAnnotations(){
        MapView.removeAnnotations(annotations)
        annotations.removeAll(keepCapacity: false)
    }
    func makeAnnotationsFromAssets(){
        let assets = Assets.sharedInstance.retriveAllAsets()
        for ass in assets {
            let ann = AnnotationView(asset: ass)
            annotations.append(ann)
        }
    }
    func addRandomAssetToMap(){
        if let ass: Asset = Assets.sharedInstance.addAsset(
            //latitude : 48.85815,
            //longitude :2.29452,
            latitude: 38.560884 + makeRand("latitude"),
            longitude: -121.422357 + makeRand("longitude"),
            title: "New Asset"){
                let ann = AnnotationView(asset: ass)
                annotations.append(ann)
        }
    }
 //   func addRandomAsset(title:String){
//        let entityDescription = NSEntityDescription.entityForName("AssetsTable",inManagedObjectContext: managedObjectContext!)
//        let ass = AssetEntity(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
//        ass.location?.setByAddingObject(Location(
//            latitude: 38.560884 + makeRand("latitude"),
//            longitude: -121.422357 + makeRand("longitude")))
//        ass.title = title
//        ass.date = NSDate()
//        ass.audio = NSData(contentsOfURL: NSURL.fileURLWithPath( NSBundle.mainBundle().pathForResource("55", ofType: "mp3")!))!
//        
//        for i in 0...10{
//            let att = NSEntityDescription.insertNewObjectForEntityForName("Attributes", inManagedObjectContext: self.managedObjectContext!) as! AssetAttributeEntity
//            att.attributeName = "att \(i)"
//            att.attributeData = "data \(i)"
//            att.asset = ass
//        }
//        do {
//            try managedObjectContext?.save()
//        } catch _ {
//            print ("error saving data in coredata")
//        }
//        let asset : Asset = Asset()
//        for l in ass.location!{
//        asset.locations.append(l as! Location)
//        }
//        asset.audio = ass.audio!
//        asset.title = ass.title!
//        let ann = AnnotationView(asset: asset)
//        annotations.append(ann)
 //   }
//    func makeImageArray(){
//        for x in 1...5{
//            let urlstring = String(stringLiteral:"http://www.streetsignpictures.com/images/225_traffic\(x).jpg")
//            let imageurl = NSURL(string: urlstring)!
//            if let imagedata = NSData(contentsOfURL: imageurl) {
//                let d : [NSObject:AnyObject] = [
//                    kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
//                    //kCGImageSourceShouldAllowFloat : true,
//                    kCGImageSourceCreateThumbnailWithTransform: true,
//                    //kCGImageSourceCreateThumbnailFromImageAlways: false,
//                    kCGImageSourceThumbnailMaxPixelSize: 100
//                ]
//                let cgimagesource = CGImageSourceCreateWithData(imagedata, d)
//                let imref = CGImageSourceCreateThumbnailAtIndex(cgimagesource!, 0, d)
//                let im = UIImage(CGImage:imref!, scale:0.2, orientation:.Up)
//                
//                //let image = UIImage(data:imagedata)!
//                //CGImageSourceCreateThumbnailAtIndex(image.CGImage, , )
//                //imagearray.append(image)
//                //}
//                
//                imagearray.append(im)
//            }
//            
//        }
//    }
    
    
}

