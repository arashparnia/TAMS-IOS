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

class AssetViewController: UIViewController,UITableViewDataSource , UITableViewDelegate{
   
    var asset = NSObject()
    
   
    @IBOutlet weak var smallMap: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var assetTitleLabel: UILabel!
    @IBOutlet weak var assetTableView: UITableView!
    
    override func viewDidLoad() {
        assetTableView.delegate = self
        assetTableView.dataSource = self
       
      
        
        var rightSaveBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveTapped:")
        self.navigationItem.setRightBarButtonItems([rightSaveBarButtonItem], animated: true)
        
       
        if let theasset = (asset as? Asset){
        let annotation = MKPointAnnotation()
        annotation.coordinate = theasset.location.coordinate
        annotation.title = theasset.title
        annotation.subtitle = theasset.location.description
        smallMap.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: theasset.location.coordinate, span: span)
        smallMap.setRegion(region, animated: true)
        smallMap.showsBuildings = true
        
        assetTitleLabel.text = theasset.title
        locationLabel.text = theasset.location.description
        }
        
    }
    func saveTapped(sender:UIButton) {
        println("search pressed")
    }
   
    
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((asset as? Asset) != nil) {
            return (asset as! Asset).categories.count
        } else {
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AssetViewReusableCell", forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        if let c = (cell as? AssetViewCellView){
            if let theasset = (asset as? Asset) {
                c.assetViewCellCatagory.text = theasset.categories[indexPath.row].category
                c.assetViewCellDescription.text = theasset.categories[indexPath.row].detail
            }
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
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
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