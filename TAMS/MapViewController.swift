//
//  ViewController.swift
//  TAMS
//
//  Created by arash on 8/16/15.
//  Copyright (c) 2015 arash. All rights reserved.
//

import UIKit
import MapKit



class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate {
 @IBOutlet weak var MapView: MKMapView!
    let radious = 0.005
    var locations : [CLLocationCoordinate2D]=[]
    var annotations:[AnnotationView] = []
    
   
    // random generator
 
    override func viewDidLoad() {
        MapView.delegate = self
    
        var uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 1.0
        MapView.addGestureRecognizer(uilpgr)
        uilpgr.delegate = self
        
        var rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "LIST", style: UIBarButtonItemStyle.Plain, target: self, action: "listTapped:")
        var rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "searchTapped:")
        self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem,rightSearchBarButtonItem], animated: true)
        
       

       
        
       makeAnnotationsFromAssets()
    
        let centerLocation = CLLocationCoordinate2D(
            latitude : 38.560884,
            longitude : -121.422357
        )
       
        MapView.addAnnotations(annotations)
        MapView.showAnnotations(annotations, animated: true)
      
        let span = MKCoordinateSpanMake(radious, radious)
        let region = MKCoordinateRegion(center: centerLocation, span: span)
        MapView.setRegion(region, animated: true)
        
        
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
        var polyline =  MKPolyline(coordinates: &points, count: points.count)
        MapView.addOverlay(polyline)
    
     
       super.viewDidLoad()
        
    }
    func makeAnnotationsFromAssets(){
        annotations.removeAll(keepCapacity: false)
        for ass in Assets.sharedInstance.assets as [String:Asset]{
            //locations.append(CLLocationCoordinate2D( latitude: ass.latitude,longitude: ass.longitude))
            let ann = AnnotationView(title: ass.1.title,subTitle:ass.0,coordinate:ass.1.location.coordinate)
            annotations.append(ann)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    var address = "1 Infinite Loop, CA, USA"
//    var geocoder = CLGeocoder()
//    geocoder.geocodeAddressString(address, {(placemarks: [AnyObject]!, error: NSError!) -> Void in
//    if let placemark = placemarks?[0] as? CLPlacemark {
//    self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
//    }
//    })
    
        // 4
    func searchTapped(sender:UIButton) {
            println("search pressed")
    }
        // 5
    func listTapped (sender:UIButton) {
            println("list pressed")
        performSegueWithIdentifier("TableView", sender: nil)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? AnnotationView {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            }
            return view
        }
        return nil
    }
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let v = view.annotation as! AnnotationView
        performSegueWithIdentifier("MapToAssetView", sender: v.subTitle)
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        Assets.sharedInstance.retriveAssetsAtRegin(mapView.region)
        //        let maxspan = MKCoordinateSpanMake(0.05, 0.05)
        //        if mapView.region.span.latitudeDelta >  maxspan.latitudeDelta {
        //            mapView.removeAnnotations(annotations)
        //        } else {
        //            MapView.addAnnotations(annotations)
        //        }
        makeAnnotationsFromAssets()
        mapView.addAnnotations(annotations)
    }
    func mapView(mapView: MKMapView!, regionWillChangeAnimated animated: Bool) {
        
 
    }
    
    //MARK:- MapViewDelegate methods
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
    return nil
    }
    
    func action(gestureRecognizer:UIGestureRecognizer) {
        var touchPoint = gestureRecognizer.locationInView(self.MapView)
        var newCoordinate:CLLocationCoordinate2D = MapView.convertPoint(touchPoint, toCoordinateFromView: self.MapView)
        var newAnnotation = MKPointAnnotation()
        let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
        let ann = AnnotationView(title: "NEW PIN", subTitle:location.description, coordinate: location.coordinate)
        MapView.addAnnotation(ann)
        //let span = MKCoordinateSpanMake(radious+0.001, radious+0.001)
        //let region = MKCoordinateRegion(center: ann.coordinate, span: span)
        //MapView.setRegion(region, animated: true)
        MapView.showAnnotations([ann], animated: true)
        Assets.sharedInstance.addAsset(location, title: "NEW PIN", subtitle: location.description)
    }

    
//    let regionRadius: CLLocationDistance = 1000
//    
//    func centerMapOnLocation(location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
//            regionRadius * 2.0, regionRadius * 2.0)
//        MapView.setRegion(coordinateRegion, animated: true)
//    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MapToAssetView"{
            let assetVC = segue.destinationViewController as! AssetViewController
            assetVC.asset = Assets.sharedInstance.findAssetWithKey(sender! as! String)!
        } else if segue.identifier == "TableView"{
            let TableVC = segue.destinationViewController as! TableViewController
        }
    }
}

