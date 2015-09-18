//
//  TableViewControllerNodesTableViewController.swift
//  TAMS
//
//  Created by arash on 8/17/15.
//  Copyright (c) 2015 arash. All rights reserved.
//

import UIKit
import MapKit

class TableViewController: UITableViewController {
   
    
    @IBOutlet var assetTableView: UITableView!
 
    let allassets: [Asset] = Assets.sharedInstance.retriveAllAsets()
    var regin : MKCoordinateRegion = MKCoordinateRegion()
    var allassetsAtRegion : [Asset] {
        get {
            return Assets.sharedInstance.retriveAllAsets()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        self.clearsSelectionOnViewWillAppear = true
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return allassets.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TheCell", forIndexPath: indexPath) 
        _ = indexPath.row
        if let c = (cell as? TableViewCellView) {
            let ass = allassets[indexPath.row]
            c.cellViewImage?.image = UIImage( data: allassets[indexPath.row].image)
            c.cellViewTitle?.text = allassets[indexPath.row].title
            c.cellViewSubtitle?.text =  "\(ass.latitude),\(ass.longitude),\(ass.date)"
            c.asset = allassets[indexPath.row]
        }
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let c = (tableView.cellForRowAtIndexPath(indexPath) as? TableViewCellView){
            print(c.cellViewSubtitle.text!)
            performSegueWithIdentifier("TableViewToAssetView", sender: c)
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
            let thecell = sender as! TableViewCellView
            assetVC.asset = thecell.asset
        }
    }






}



