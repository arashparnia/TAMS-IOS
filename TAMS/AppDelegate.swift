//
//  AppDelegate.swift
//  TAMS
//
//  Created by arash on 8/16/15.
//  Copyright (c) 2015 arash. All rights reserved.
//

import UIKit
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let radious = 0.005
    
    func makeRand() -> Double{
        let lower : UInt32 = 100000
        let upper : UInt32 = 999999
        var randomNumber = arc4random_uniform(upper - lower) + lower
        var rand : Double = Double(randomNumber)
        rand = radious - rand / 100000000
        return Double(rand)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        for index in 0...5 {
            let lat : Double  = 38.560884 + makeRand()
            let lon : Double  = -121.422357 + makeRand()
            let title: String = "NODE \(index)"
            let location = CLLocation(latitude: lat, longitude: lon)
            var categories : [Assetcategory] = [Assetcategory]()
            for i in 0...5 {
                categories.append( Assetcategory(category: "name \(i)", detail: "details \(i)"))
            }
            Assets.sharedInstance.addAsset(location , title: title, subtitle: location.description,categories: categories) // random ASSETS are being added
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

