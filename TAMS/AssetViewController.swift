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
import MobileCoreServices

class AssetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{
    var asset = Asset()
    var newMedia: Bool?
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var smallMap: MKMapView!
    //@IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var assetTitleLabel: UITextField!
    @IBOutlet weak var assetTableView: UITableView!
    @IBOutlet weak var audiobutton: UIButton!
    //       @IBAction func addAttribute(sender: UIButton) {
    //        println("\(self.attributeName.text):\(attributeValue.text)")
    //        let assatt = AssetAttribute()
    //        assatt.attributeName = attributeName.text
    //        assatt.attributeData = attributeValue.text
    //        asset.attributes.append(assatt)
    //        assetTableView.reloadData()
    //        attributeName.text = ""
    //        attributeValue.text = ""
    //    }
    
    var tempimage  = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assetTableView.delegate = self
        assetTableView.dataSource = self
        //attributeValue.delegate = self
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let annotation = MKPointAnnotation()
        annotation.coordinate =  CLLocation(latitude: asset.latitude, longitude: asset.longitude).coordinate
        annotation.title = asset.title
        smallMap.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: CLLocation(latitude: asset.latitude, longitude: asset.longitude).coordinate, span: span)
        smallMap.setRegion(region, animated: true)
        smallMap.showsBuildings = true
        
        image.image = UIImage(data:asset.image)
        assetTitleLabel.text = asset.title
        //locationLabel.text = "\(asset.latitude),\(asset.longitude)"
        
        //ShowAttributeAddViews(false)
    }
    //    func textFieldShouldReturn(textField: UITextField) -> Bool {
    //        println("returned\(textField)")
    //        if textField == attributeValue{
    //
    //            addAttribute(attributeAddButton)
    //            textField.resignFirstResponder()
    //        }
    //        return true
    //    }
    //    func ShowAttributeAddViews(state: Bool){
    //        attributeName.enabled = state
    //        attributeValue.enabled = state
    //        attributeAddButton.enabled=state
    //        attributeName.hidden = !state
    //        attributeValue.hidden = !state
    //        attributeAddButton.hidden = !state
    //        attributeName.text = ""
    //        attributeValue.text = ""
    //    }

    func imageTapped(img: AnyObject)
    {
        println("image pressed")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage as NSString]
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
            newMedia = true
        }
    }
    
    func useCameraRoll(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
                newMedia = false
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        self.dismissViewControllerAnimated(true, completion: nil)
        if mediaType == (kUTTypeImage as! String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            removeImageViewSubviews(self.image)
            self.image.image = image
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                    "image:didFinishSavingWithError:contextInfo:", nil)
            } else if mediaType == (kUTTypeMovie as! String) {
                // Code to support video here
            }
            
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }
    
    func removeImageViewSubviews( img : UIImageView){
        for sv in img.subviews{
            sv.removeFromSuperview()
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        if editing {
            println("edit ")
            //ShowAttributeAddViews(true)
            assetTableView.editing = true
            var imagegesture = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
            image.addGestureRecognizer(imagegesture)
            editImage()
            audiobutton.setImage(UIImage(named: "microphone"), forState: UIControlState.Normal)
            assetTableView.reloadData()
        } else {
            println("save ")
            // ShowAttributeAddViews(false)
            image.gestureRecognizers?.removeAll(keepCapacity: false)
            assetTableView.editing = false
            removeImageViewSubviews(image)
            UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
            asset.title = assetTitleLabel.text
            audiobutton.setImage(UIImage(named: "play"), forState: UIControlState.Normal)
            assetTableView.reloadData()
        }
        
        super.setEditing(editing, animated: animated)
    }
    
    
    func editImage(){
        let drawText = "EDIT"
        
        var effect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        var blurView = UIVisualEffectView(effect: effect)
        blurView.frame = image.bounds
        
        var cam =  UIImageView(image: UIImage(named: "Camera.png"))
        cam.frame = CGRectMake(0, 0, 20, 20)
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
    //
    //    IBAction func playAudio(sender: AnyObject) {
    //
    //        var playing = false
    //
    //        if let currentPlayer = player {
    //            playing = player.playing;
    //        }else{
    //            return;
    //        }
    //
    //        if !playing {
    //            let filePath = NSBundle.mainBundle().pathForResource("3e6129f2-8d6d-4cf4-a5ec-1b51b6c8e18b", ofType: "wav")
    //            if let path = filePath{
    //                let fileURL = NSURL(string: path)
    //                player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
    //                player.numberOfLoops = -1 // play indefinitely
    //                player.prepareToPlay()
    //                player.delegate = self
    //                player.play()
    //
    //                displayLink = CADisplayLink(target: self, selector: ("updateSliderProgress"))
    //                displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode!)
    //            }
    //
    //        } else {
    //            player.stop()
    //            displayLink.invalidate()
    //        }
    //    }
    //
    //    func updateSliderProgress(){
    //        var progress = player.currentTime / player.duration
    //        timeSlider.setValue(Float(progress), animated: false)
    //    }
    
    // TABLE VIEW DELEGATE METHODS
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView.editing {return 2} else {return 1}
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //let title = section == 1 ? "New" : "Current"
        if tableView.editing {
            if section == 1 {
                return "Assets"
            } else {
                return "Add new asset"
            }
        }else {
            return "Assets"
        }
       
    }
    //    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
    //
    //    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.editing {
            if section == 0 {
                return 1
            }else{
                return asset.attributes.count
            }
        } else {
            return asset.attributes.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView.editing  {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("AssetAddReusableCell", forIndexPath: indexPath) as! UITableViewCell
                let c =  cell as! AssetAttributeAddCellView
                c.attributeName.text = ""
                c.attributeValue.text = ""
                return cell
            }else {
                let cell = tableView.dequeueReusableCellWithIdentifier("AssetViewReusableCell", forIndexPath: indexPath) as! UITableViewCell
                let c =  cell as! AssetViewCellView
                c.attribute.text  = asset.attributes[indexPath.row].attributeName
                c.value.text = asset.attributes[indexPath.row].attributeData
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("AssetViewReusableCell", forIndexPath: indexPath) as! UITableViewCell
            let c =  cell as! AssetViewCellView
            c.attribute.text  = asset.attributes[indexPath.row].attributeName
            c.value.text = asset.attributes[indexPath.row].attributeData
            return cell
        }
        
        
    }
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            if let c = (tableView.cellForRowAtIndexPath(indexPath) as? TableViewCellView){
                println(c.cellViewSubtitle.text!)
                //performSegueWithIdentifier("TableViewToAssetView", sender: c.cellViewSubtitle.text!)
                //tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
        //        func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        //            println("tapped")
        //            let cell = tableView.dequeueReusableCellWithIdentifier("AssetViewReusableCell", forIndexPath: indexPath) as! UITableViewCell
        //            if let c =  cell as? AssetViewCellView {
        //                println(asset.attributes[c.tag].attributeName)
        //            }
        //        }
        
        /*
        // Override to support conditional editing of the table view.
        override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
        }
        */
        
        
        // Override to support editing the table view.
        //    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        ////        let thecell = tableView.cellForRowAtIndexPath(indexPath) as! AssetViewCellView
        ////        asset.attributes[indexPath.row].attributeName =  thecell.assetViewCellAttribute.text
        ////        asset.attributes[indexPath.row].attributeData =  thecell.assetViewCellValue.text
        ////
        //        if editingStyle == .Delete {
        //    // Delete the row from the data source
        //        asset.attributes.removeAtIndex(indexPath.row)
        //        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        //    } else if editingStyle == .Insert {
        //    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        //    }
        //    }
        //    }
        
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