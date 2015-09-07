//
//  Asset.swift
//  TAMS
//
//  Created by arash on 8/31/15.
//  Copyright (c) 2015 arash. All rights reserved.
//

import Foundation
import CoreData

class AssetEntity: NSManagedObject {
    @NSManaged var image: NSData
    @NSManaged var audio: NSData
    @NSManaged var date: NSDate
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var title: String
    @NSManaged var attributes: NSSet

}
