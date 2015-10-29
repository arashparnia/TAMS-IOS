//
//  PolyLineViewController.swift
//  TAMS
//
//  Created by arash on 10/26/15.
//  Copyright © 2015 arash. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData
import ImageIO
import AVFoundation


class PolyLineViewController: UIViewController,MKMapViewDelegate,UIGestureRecognizerDelegate{
    let currentPath : UIBezierPath = UIBezierPath()
    var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    var assetNSManagedObjectID : NSManagedObjectID = NSManagedObjectID()
    
    override func viewDidLoad() {
        let centerLocation = CLLocationCoordinate2D(
            latitude : 38.560884,
            longitude : -121.422357
        )
        mapView.region.center = centerLocation
        mapView.region.span = MKCoordinateSpanMake(0.1, 0.1)
        mapView.mapType = .Standard
        
        mapView.delegate = self
        mapView.userInteractionEnabled = false
        
//        let editBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Bookmarks, target: self, action: "listTapped:")
//       
//        self.navigationItem.setRightBarButtonItems([rightListBarButtonItem,rightSearchBarButtonItem], animated: true)

        self.navigationItem.setRightBarButtonItem(self.editButtonItem(), animated: true)
//
//        self.navigationItem.rightBarButtonItem!.target = self;
//        //self.navigationItem.rightBarButtonItem!.action = @selector(actionForTap:);
//        self.navigationItem.rightBarButtonItem!.target .
//            //addTarget(self, action: "actioncall", forControlEvents: UIControlEvents.TouchUpInside)
    
        
        super.viewDidLoad()
    }
    override func setEditing(editing: Bool, animated: Bool) {
        if editing {mapView.userInteractionEnabled  = false}
        else {mapView.userInteractionEnabled  = true}
        super.setEditing(editing, animated: animated)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if editing{
            let overlays = mapView.overlays
            mapView.removeOverlays(overlays)
        }
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if editing {
        
        for touch in touches {
            points.append(mapView.convertPoint(touch.locationInView(mapView), toCoordinateFromView: self.mapView))
        }
        let polyline =  MKPolyline(coordinates: &points, count: points.count)
        mapView.addOverlay(polyline)
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if editing {
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        let polyline =  MKPolyline(coordinates: &points, count: points.count)
        mapView.addOverlay(polyline)
        points.removeAll()
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.blueColor()
        polylineRenderer.lineWidth = 2
        return polylineRenderer
    }
    
}