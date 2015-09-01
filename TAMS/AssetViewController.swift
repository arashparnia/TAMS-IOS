//
//  AssetViewController.swift
//  TAMS
//
//  Created by arash on 8/23/15.
//  Copyright (c) 2015 arash. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AssetViewController: UIViewController, UITableViewDataSource,UITableViewDelegate{
   
    @IBOutlet weak var image: UIImageView!
    var asset = Asset()
    @IBOutlet weak var smallMap: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var assetTitleLabel: UILabel!
    @IBOutlet weak var assetTableView: UITableView!
    
    var tempimage  = UIImageView()
    
    override func viewDidLoad() {
        assetTableView.delegate = self
        assetTableView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let annotation = MKPointAnnotation()
        annotation.coordinate =  CLLocation(latitude: asset.latitude, longitude: asset.longitude).coordinate
        annotation.title = asset.title
        smallMap.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: CLLocation(latitude: asset.latitude, longitude: asset.longitude).coordinate, span: span)
        smallMap.setRegion(region, animated: true)
        smallMap.showsBuildings = true
        
        assetTitleLabel.text = asset.title
        locationLabel.text = "\(asset.latitude),\(asset.longitude)"
    
    
        
        
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        if editing {
             println("edit ")
            editImage()
        } else {
            println("save ")
            for sv in image.subviews{
                sv.removeFromSuperview()
            }
            UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
            
        }
        
        super.setEditing(editing, animated: animated)
    }
    
   
    func editImage(){
        let drawText = "EDIT"
    
        var effect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        var blurView = UIVisualEffectView(effect: effect)
        blurView.frame = image.bounds
       
        var cam =  UIImageView(image: UIImage(named: "Camera.png"))
        cam.center = CGPoint(x: 50, y: 50)
        
        image.addSubview(blurView)
        image.addSubview(cam)
        
       
//        // Setup the font specific variables
//        var textColor: UIColor = UIColor.whiteColor()
//        var textFont: UIFont = UIFont(name: "Helvetica Bold", size: 62)!
//        
//        //Setup the image context using the passed image.
//        UIGraphicsBeginImageContext(inImage.size)
//        
//        //Setups up the font attributes that will be later used to dictate how the text should be drawn
//        let textFontAttributes = [ NSFontAttributeName: textFont, NSForegroundColorAttributeName: textColor,]
//        
//        //Put the image into a rectangle as large as the original image.
//        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
//        
//        // Creating a point within the space that is as bit as the image.
//        var rect: CGRect = CGRectMake(20, 20, inImage.size.width, inImage.size.height)
//        
//        //Now Draw the text into an image.
//        drawText.drawInRect(rect, withAttributes: textFontAttributes)
//        
//        // Create a new image out of the images we have created
//        inImage = UIGraphicsGetImageFromCurrentImageContext()
//        
//        // End the context now that we have the image we need
//        UIGraphicsEndImageContext()
        
       
        
       
        
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return asset.attributes.count
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AssetViewReusableCell", forIndexPath: indexPath) as! UITableViewCell
        if let c =  cell as? AssetViewCellView {
            c.assetViewCellAttribute.text = asset.attributes[indexPath.row].attributeName
            c.assetViewCellValue.text = asset.attributes[indexPath.row].attributeData
        }
        return cell
    }
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let c = (tableView.cellForRowAtIndexPath(indexPath) as? TableViewCellView){
            println(c.cellViewSubtitle.text!)
            //performSegueWithIdentifier("TableViewToAssetView", sender: c.cellViewSubtitle.text!)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
//
//       // MARK: - Navigation
//    
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "TableViewToAssetView"{
//            let assetVC = segue.destinationViewController as! AssetViewController
//            let key = sender as! String
//            let asset = Assets.sharedInstance.findAssetWithKey(key)
//            assetVC.theLocation = asset!.location
//            assetVC.theTitle = asset!.title
//        }
//    }
    
    

 
}