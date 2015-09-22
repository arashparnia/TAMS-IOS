//
//  AssetAttributeEntity+CoreDataProperties.swift
//  TAMS
//
//  Created by arash on 9/19/15.
//  Copyright © 2015 arash. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AssetAttributeEntity {

    @NSManaged var attributeData: String?
    @NSManaged var attributeName: String?
    @NSManaged var asset: AssetEntity?

}
