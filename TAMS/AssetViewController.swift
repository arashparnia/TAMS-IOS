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
import AVFoundation


class AssetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate{
    var asset = Asset()
    var newMedia: Bool?
    var audioPlayer: AVAudioPlayer!
    var audioRecorder: AVAudioRecorder!
    var updater : CADisplayLink! = nil
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var smallMap: MKMapView!
    @IBOutlet weak var assetTitleLabel: UITextField!
    @IBOutlet weak var assetTableView: UITableView!
    @IBOutlet weak var audiobutton: UIButton!
    @IBOutlet weak var audioprogressbar: UIProgressView!
    
    @IBAction func audiobottunpressed(sender: UIButton) {
        if assetTableView.editing{
            if audiobutton.selected{
                audioRecorder.stop()
                
                audiobutton.selected = false
            } else {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    let recordurl = NSURL()
                    let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
                        AVFormatIDKey : NSNumber(unsignedInt: kAudioFormatLinearPCM),
                        AVEncoderBitRateKey: 16,
                        AVNumberOfChannelsKey: 2,
                        AVSampleRateKey: 44100.0]
                    try! self.audioRecorder = AVAudioRecorder(URL: recordurl, settings: recordSettings )
                    self.audioRecorder.record()
                  
                } else {
                    print("Permission to record not granted")
                }
            })
            audiobutton.selected=true
            }
        } else {
            if audiobutton.selected{
                audioPlayer.stop()
                audiobutton.selected = false
            }else {
                audioPlayer.play()
                audiobutton.selected = true
            }
        }
        
    }

    var tempimage  = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assetTableView.delegate = self
        assetTableView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let annotation = MKPointAnnotation()
        
        for l in asset.locations{
            annotation.coordinate =  CLLocation(latitude: l.latitude, longitude: l.longitude).coordinate
        }
        annotation.title = asset.title
        smallMap.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude).coordinate, span: span)
        
        smallMap.showsBuildings = true
        if #available(iOS 9.0, *) {
            smallMap.mapType = .HybridFlyover
            let camera = MKMapCamera(lookingAtCenterCoordinate: annotation.coordinate, fromDistance: 500, pitch: 65, heading: 0)
            smallMap.setCamera(camera, animated: true)
        } else {
            // Fallback on earlier versions
            smallMap.mapType = .Hybrid
            smallMap.setRegion(region, animated: true)
        }
        
        
        image.image = UIImage(data:asset.image)
        assetTitleLabel.text = asset.title
        

        
        //let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        //let docsDir = dirPaths[0]
        //let soundFilePath = docsDir.stringByAppendingPathComponent("sound.wav")
//        let soundFileURL = NSURL().URLByAppendingPathComponent("sound.wav")
//        let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
//            AVFormatIDKey : NSNumber(unsignedInt: kAudioFormatLinearPCM),
//            AVEncoderBitRateKey: 16,
//            AVNumberOfChannelsKey: 2,
//            AVSampleRateKey: 44100.0]
//        var error: NSError?
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
//        } catch let error1 as NSError {
//            error = error1
//        }
//        if let err = error {
//            print("audioSession error: \(err.localizedDescription)")
//        }
//        do {
//            audioRecorder = try AVAudioRecorder(URL: soundFileURL, settings: recordSettings)
//        } catch let error1 as NSError {
//            error = error1
//            audioRecorder = nil
//        }
//        audioRecorder.delegate = self
//        
//        if let err = error {
//            print("audioSession error: \(err.localizedDescription)")
//        } else {
//            audioRecorder?.prepareToRecord()
//        }
//        
        let u = NSURL.fileURLWithPath( NSBundle.mainBundle().pathForResource("55", ofType: "mp3")!)
        var e: NSError?
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: u)
        } catch let error as NSError {
            e = error
            self.audioPlayer = nil
        }
        if let error = e {
            print("audioPlayer error \(error.localizedDescription)")
        }
        else {
            audioPlayer.numberOfLoops = 0
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            updater = CADisplayLink(target: self, selector: Selector("trackAudio"))
            updater.frameInterval = 1
            updater.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        }
        
       
        
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            print("recorded")
            //asset.audio = nsdata( recorder.url
           self.audioPlayer = try? AVAudioPlayer(contentsOfURL: recorder.url)
            
        } else {
            print("problem saving or something ")
        }
    }
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if flag{
            audiobutton.selected = false
        }
    }
    func trackAudio() {
        audioprogressbar.setProgress(Float(audioPlayer.currentTime  / audioPlayer.duration), animated: false)
    }

    
    func imageTapped(img: AnyObject)
    {
        print("image pressed")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
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
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
                newMedia = false
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        self.dismissViewControllerAnimated(true, completion: nil)
        if mediaType == (kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            removeImageViewSubviews(self.image)
            self.image.image = image
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                    "image:didFinishSavingWithError:contextInfo:", nil)
            } else if mediaType == (kUTTypeMovie as String) {
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
            print("edit ")
            //ShowAttributeAddViews(true)
            assetTableView.editing = true
            let imagegesture = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
            image.addGestureRecognizer(imagegesture)
            editImage()
            audiobutton.setImage(UIImage(named: "microphone"), forState: UIControlState.Normal)
            assetTableView.reloadData()
        } else {
            print("save ")
            // ShowAttributeAddViews(false)
            image.gestureRecognizers?.removeAll(keepCapacity: false)
            assetTableView.editing = false
            removeImageViewSubviews(image)
            UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
            asset.title = assetTitleLabel.text!
            audiobutton.setImage(UIImage(named: "play"), forState: UIControlState.Normal)
            assetTableView.reloadData()
        }
        
        super.setEditing(editing, animated: animated)
    }
    
    
    func editImage(){
        _ = "EDIT"
        
        let effect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = image.bounds
        
        let cam =  UIImageView(image: UIImage(named: "Camera.png"))
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
    
//        func playAudio(sender: AnyObject) {
//    
//            var playing = false
//    
//            if let currentPlayer = audioPlayer {
//                playing = audioPlayer!.playing;
//            }else{
//                return;
//            }
//    
//            if !playing {
//                let filePath = NSBundle.mainBundle().pathForResource("3e6129f2-8d6d-4cf4-a5ec-1b51b6c8e18b", ofType: "wav")
//                if let path = filePath{
//                    let fileURL = NSURL(string: path)
//                    player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
//                    player.numberOfLoops = -1 // play indefinitely
//                    player.prepareToPlay()
//                    player.delegate = self
//                    player.play()
//    
//                    displayLink = CADisplayLink(target: self, selector: ("updateSliderProgress"))
//                    displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode!)
//                }
//    
//            } else {
//                player.stop()
//                displayLink.invalidate()
//            }
//        }
//    
//        func updateSliderProgress(){
//            var progress = player.currentTime / player.duration
//            timeSlider.setValue(Float(progress), animated: false)
//        }
    
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
                let cell = tableView.dequeueReusableCellWithIdentifier("AssetAddReusableCell", forIndexPath: indexPath) 
                let c =  cell as! AssetAttributeAddCellView
                c.attributeName.text = ""
                c.attributeValue.text = ""
                return cell
            }else {
                let cell = tableView.dequeueReusableCellWithIdentifier("AssetViewReusableCell", forIndexPath: indexPath) 
                let c =  cell as! AssetViewCellView
                c.attribute.text  = asset.attributes[indexPath.row].attributeName
                c.value.text = asset.attributes[indexPath.row].attributeData
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("AssetViewReusableCell", forIndexPath: indexPath) 
            let c =  cell as! AssetViewCellView
            c.attribute.text  = asset.attributes[indexPath.row].attributeName
            c.value.text = asset.attributes[indexPath.row].attributeData
            return cell
        }
        
        
    }
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            if let c = (tableView.cellForRowAtIndexPath(indexPath) as? TableViewCellView){
                print(c.cellViewSubtitle.text!)
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
        
    
        // Override to support conditional editing of the table view.
        func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            if tableView.editing && indexPath.section == 0 && indexPath.row == 0 {
                return false
            }
        // Return NO if you do not want the specified item to be editable.
        return true
        }
    
        
        
    //Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
        //        let thecell = tableView.cellForRowAtIndexPath(indexPath) as! AssetViewCellView
        //        asset.attributes[indexPath.row].attributeName =  thecell.assetViewCellAttribute.text
        //        asset.attributes[indexPath.row].attributeData =  thecell.assetViewCellValue.text
        //
        if editingStyle == .Delete {
            // Delete the row from the data source
            asset.attributes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }


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