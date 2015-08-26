//
//  TableViewControllerNodesTableViewController.swift
//  TAMS
//
//  Created by arash on 8/17/15.
//  Copyright (c) 2015 arash. All rights reserved.
//

import UIKit
import MapKit

class TableViewController: UITableViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    @IBOutlet var assetTableView: UITableView!
    let allkeys: [String] = Assets.sharedInstance.retriveAllKeys()
    let alltitles: [String] = Assets.sharedInstance.retriveAllTitles()
    let allassets: [Asset] = Assets.sharedInstance.retriveAllAsets()
    var regin : MKCoordinateRegion = MKCoordinateRegion()
    var allassetsAtRegion : [Asset] {
        get {
            return Assets.sharedInstance.retriveAssetsAtRegin(regin)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        self.clearsSelectionOnViewWillAppear = true
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() 
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allkeys.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TheCell", forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        if let c = (cell as? TableViewCellView) {
            c.cellViewTitle?.text = allassets[indexPath.row].title //alltitles[indexPath.row]
            c.cellViewSubtitle?.text = allassets[indexPath.row].description
            c.cellViewImage?.image = allassets[indexPath.row].image
        }
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let c = (tableView.cellForRowAtIndexPath(indexPath) as? TableViewCellView){
           let key = c.cellViewSubtitle
            performSegueWithIdentifier("TableViewToAssetView", sender: key)
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

// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TableViewToAssetView"{
            let assetVC = segue.destinationViewController as! AssetViewController
            let key = sender as! String
            let asset = Assets.sharedInstance.findAssetWithKey(key)
            assetVC.theLocation = asset!.location
            assetVC.theTitle = asset!.title
        }
    }



//        if segue.identifier == blogSegueIdentifier {
//            if let destination = segue.destinationViewController as? BlogViewController {
//                if let blogIndex = tableView.indexPathForSelectedRow()?.row {
//                    destination.blogName = swiftBlogs[blogIndex]
//                }
//            }
//        }
//        if let assetViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AssetView") as? AssetViewController{
//            //         let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
//            //        let key = cell.detailTextLabel!.text
//            //        if let asset = Assets.sharedInstance.findAssetWithKey(key!){
//            //
//            //        assetViewController.setPropertiesFor(asset.title!, latitude: asset.latitude, longitude: asset.longitude)
//            //
//            assetViewController.assetTitleLabel.text = "TESTING"
//
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//          }
//



}



