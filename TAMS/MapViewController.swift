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
import LocalAuthentication

class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate,NSFetchedResultsControllerDelegate {
    let centerLocation = CLLocationCoordinate2D(
        latitude : 38.560884,
        longitude : -121.422357
    )
    let radious = 0.1
    var locations : [CLLocationCoordinate2D]=[]
    var annotations:[AnnotationView] = []
    let clusteringManager = FBClusteringManager()
    @IBOutlet weak var MapView: MKMapView!
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
        frc.delegate = self
        return frc
        }()

  
    override func viewDidLoad() {
      authenticateUser()
        MapView.delegate = self
        // gesture and bottons setup
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        //let ft = UIForceTouchCapability.Available
        uilpgr.minimumPressDuration = 0.5
        MapView.addGestureRecognizer(uilpgr)
        uilpgr.delegate = self
        
        let rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "LIST", style: UIBarButtonItemStyle.Plain, target: self, action: "listTapped:")
        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "searchTapped:")
        self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem,rightSearchBarButtonItem], animated: true)
        
    
        
        //addRandomAssetToMap()

        configureAnnotations()
    
        clusteringManager.addAnnotations(annotations)
        
      
        
        //POLY LINE
//        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
//        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.001, longitude: -121.422357 + 0.001))
//        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.002, longitude: -121.422357 + 0.001))
//        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.001, longitude: -121.422357 + 0.002))
//        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.003, longitude: -121.422357 + 0.003))
//        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.005, longitude: -121.422357 + 0.003))
//        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.003, longitude: -121.422357 + 0.006))
//        points.append(CLLocationCoordinate2D(latitude: 38.560884 - 0.003, longitude: -121.422357 - 0.003))
//        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.001, longitude: -121.422357 + 0.001))
//        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.002, longitude: -121.422357 + 0.001))
//        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.001, longitude: -121.422357 + 0.002))
//        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.003, longitude: -121.422357 + 0.003))
//        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.005, longitude: -121.422357 + 0.003))
//        points.append(CLLocationCoordinate2D(latitude: 38.560884 + 0.003, longitude: -121.422357 + 0.006))
//        let polyline =  MKPolyline(coordinates: &points, count: points.count)
//        MapView.addOverlay(polyline)
        MapView.showsBuildings = true
        MapView.showsUserLocation = false
        MapView.showsScale = true
        MapView.region.center = centerLocation
        MapView.region.span = MKCoordinateSpanMake(0.1, 0.1)
        let camera = MKMapCamera(lookingAtCenterCoordinate: centerLocation, fromDistance: 1000, pitch: 65, heading: 0)
        MapView.setCamera(camera, animated: true)
        MapView.mapType = .Standard
        MapView.showAnnotations(annotations, animated: true)
        super.viewDidLoad()
    }
    override func viewDidAppear(animated: Bool) {
        MapView.removeAnnotations(annotations)
        MapView.addAnnotations(annotations)
        //MapView.showAnnotations(annotations, animated: true)
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func mapType(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            MapView.mapType = .Standard
        } else {
                // Fallback on earlier versions
                MapView.mapType = .HybridFlyover
        }
            MapView.removeAnnotations(annotations)
            MapView.addAnnotations(annotations)
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
            view.image = annotation!.image
            view.detailCalloutAccessoryView = UIImageView(image: annotation!.image)
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
            let mapBoundsWidth = Double(mapView.bounds.size.width)
            let mapRectWidth:Double = mapView.visibleMapRect.size.width
            let scale:Double = mapBoundsWidth / mapRectWidth
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(mapView.visibleMapRect, withZoomScale:scale)
            self.clusteringManager.displayAnnotations(annotationArray, onMapView:mapView)
        })
        mapView.addAnnotations(annotations)
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
//        if gestureRecognizer.numberOfTouches() == 1  {
//        print("long press detected ")
//        let touchPoint = gestureRecognizer.locationInView(self.MapView)
//        let newCoordinate:CLLocationCoordinate2D = MapView.convertPoint(touchPoint, toCoordinateFromView: self.MapView)
//      
//        Assets().addAsset(latitude:newCoordinate.latitude, longitude: newCoordinate.longitude, title: "NEW ASSET")
//            if let asset = Assets().retriveAsset(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude){
//                performSegueWithIdentifier("MapToAssetView", sender: asset)
//                
//            }
//        }
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
            let anview = sender as! AnnotationView
            assetVC.assetNSManagedObjectID = anview.asset.objectID
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
        r=r/100
        return r
    }
    func configureAnnotations(){
        MapView.removeAnnotations(annotations)
        annotations.removeAll(keepCapacity: false)
        do {
            try fetchedResultsController.performFetch()
            for stuff in  fetchedResultsController.fetchedObjects!{
                let ass: AssetEntity = stuff as! AssetEntity
                annotations.append(AnnotationView(asset: ass))
            }
        } catch {
            print("Erro fetching into fetchresult controller in mapview")
        }
    }
    
    func addRandomAssetToMap(){
        Assets().addAsset(
            //latitude : 48.85815,
            //longitude :2.29452,
            latitude: 38.560884 + makeRand("latitude"),
            longitude: -121.422357 + makeRand("longitude"),
            title: "New Asset")
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
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        if traitCollection.forceTouchCapability == .Available {
            print("\(touch.tapCount) Touch  pressure is \(touch.force), maximum possible force is \(touch.maximumPossibleForce)")
            
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        if traitCollection.forceTouchCapability == .Available {
            print("Touch  pressure is \(touch.force), maximum possible force is \(touch.maximumPossibleForce)")
        }
    }
    func scaleImage(image : UIImage,scale: CGFloat)->UIImage{
        let theimage = image
        let size = CGSizeApplyAffineTransform(theimage.size, CGAffineTransformMakeScale(scale, scale))
        let hasAlpha = false
        let scale: CGFloat = 0.0
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        theimage.drawInRect(CGRect(origin: CGPointZero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }

    
    //PASSWORD MANAGMENT
    var error : NSError?
    var myLocalizedReasonString : NSString = "Authentication is required"
    func authenticateUser() {
        let context : LAContext = LAContext()
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString as String, reply: {(
                success : Bool, evaluationError : NSError?) -> Void in
                if success {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        print("sucess")
                    })
                }
                else {
                    // Authentification failed
                    print(evaluationError?.localizedDescription)
                    
                    switch evaluationError!.code {
                    case LAError.SystemCancel.rawValue:
                        print("Authentication cancelled by the system")
                    case LAError.UserCancel.rawValue:
                        print("Authentication cancelled by the user")
                    case LAError.UserFallback.rawValue:
                        print("User wants to use a password")
                        // We show the alert view in the main thread (always update the UI in the main thread)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                    default:
                        print("Authentication failed")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                    }
                }
            })
        }
        else {
            switch error!.code {
            case LAError.TouchIDNotEnrolled.rawValue:
                print("TouchID not enrolled")
            case LAError.PasscodeNotSet.rawValue:
                print("Passcode not set")
            default:
                print("TouchID not available")
            }
            self.showPasswordAlert()
        }
    }
    func showPasswordAlert() { let alertController : UIAlertController = UIAlertController(title:"TouchID Demo" , message: "Please enter password", preferredStyle: .Alert)
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            print(action)
        }
        let doneAction : UIAlertAction = UIAlertAction(title: "Done", style: .Default) { (action) -> Void in
            let passwordTextField = alertController.textFields![0] as UITextField
            self.login(passwordTextField.text!)
        }
        doneAction.enabled = false
        // We are customizing the text field using a configuration handler
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification) -> Void in
                doneAction.enabled = textField.text != ""
            })
        }
        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)
        self.presentViewController(alertController, animated: true) {
            // Nothing to do here
        }
    }
    
    func login(password: String) {
        if password == "password" {
            //self.loadData()
        } else {
            self.showPasswordAlert()
        }
    }
}

