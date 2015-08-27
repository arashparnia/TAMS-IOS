//
//  AssetCatagories.swift
//  TAMS
//
//  Created by arash on 8/27/15.
//  Copyright (c) 2015 arash. All rights reserved.
//


import Foundation



class Assetcategory : NSObject{
    
    var category : String
    var detail : String 
    
    init(category : String,detail : String){
        self.category = category
        self.detail = detail
    }
}