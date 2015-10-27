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
    
        super.viewDidLoad()
    }
    @IBOutlet weak var mapView: MKMapView!
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if event?.allTouches()?.count > 1 {
            mapView.userInteractionEnabled  = true
        } else {
            mapView.userInteractionEnabled  = false
        }

            let overlays = mapView.overlays
            mapView.removeOverlays(overlays)

    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            points.append(mapView.convertPoint(touch.locationInView(mapView), toCoordinateFromView: self.mapView))
        }
        let polyline =  MKPolyline(coordinates: &points, count: points.count)
        mapView.addOverlay(polyline)
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
      
            mapView.userInteractionEnabled  = false
        
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        let polyline =  MKPolyline(coordinates: &points, count: points.count)
        mapView.addOverlay(polyline)
        points.removeAll()
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.blueColor()
        polylineRenderer.lineWidth = 2
        return polylineRenderer
    }
    
}