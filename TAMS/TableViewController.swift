//
//  TableViewControllerNodesTableViewController.swift
//  TAMS
//
//  Created by arash on 8/17/15.
//  Copyright (c) 2015 arash. All rights reserved.
//
import CoreData
import UIKit
import MapKit

class TableViewController: UITableViewController,NSFetchedResultsControllerDelegate {
   
    
    @IBOutlet var assetTableView: UITableView!
    let assets: NSFetchedResultsController = AssetsController().retriveAllAssets()
    
    override func viewDidLoad() {
        do{
           try assets.performFetch()
        } catch{
            print("error in fetshing results")
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        self.clearsSelectionOnViewWillAppear = true
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() 
    }
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
    }
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = assets.sections {
            return sections.count
        }
        return 0
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = assets.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TheCell", forIndexPath: indexPath) as! TableViewCellView
        let assetEntity = assets.objectAtIndexPath(indexPath) as! AssetEntity
        cell.cellViewTitle.text = assetEntity.title
        cell.cellViewSubtitle.text = "\(assetEntity.latitude),\(assetEntity.longitude)"
        let image = UIImage(data:assetEntity.image!)
        let newImage = resizeImage(image!, toTheSize: CGSizeMake(50, 50))
        let cellImageLayer: CALayer?  = cell.imageView!.layer
        cellImageLayer!.cornerRadius = 25
        cellImageLayer!.masksToBounds = true
        cell.imageView!.image = newImage
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            performSegueWithIdentifier("TableViewToAssetView",
                sender: assets.objectAtIndexPath(indexPath))
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{
        let scale = CGFloat(max(size.width/image.size.width,
            size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale;
        let rr:CGRect = CGRectMake( 0, 0, width, height);
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.drawInRect(rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage
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
            let theasset = sender as! AssetEntity
            assetVC.assetNSManagedObjectID = theasset.objectID
        }
    }






}



