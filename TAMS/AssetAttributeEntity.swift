//
//  AssetAttribute.swift
//  TAMS
//
//  Created by arash on 8/30/15.
//  Copyright (c) 2015 arash. All rights reserved.
//

import Foundation
import CoreData

class AssetAttributeEntity: NSManagedObject {

    @NSManaged var attributeData: String
    @NSManaged var attributeName: String
    @NSManaged var asset: AssetEntity

}
