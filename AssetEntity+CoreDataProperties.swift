//
//  AssetEntity+CoreDataProperties.swift
//  TAMS
//
//  Created by arash on 9/24/15.
//  Copyright © 2015 arash. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AssetEntity {

    @NSManaged var audio: NSData?
    @NSManaged var date: NSDate
    @NSManaged var image: NSData?
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var title: String?
    @NSManaged var attributes: NSSet?
    @NSManaged var polyline: NSOrderedSet?

}
