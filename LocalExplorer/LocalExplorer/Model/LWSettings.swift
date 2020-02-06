//
//  LWSettings.swift
//  LocalExplorer
//
//  Created by Joshua Marriott on 4/8/19.
//  Copyright © 2019 Joshua Marriott. All rights reserved.
//

import Foundation
import CoreData

public class LWSettings{
    
    private let maxRadius = 160934.4
    private let minRadius = 160.9344
    var currentRadius:Double
    
    init(){
        currentRadius = 8046.72
    }
    
    func getMaxRadius() -> (Double){
        return maxRadius
    }
    
    func geMinRadius() -> (Double){
        return minRadius
    }
    
}

class StoredLWSettings : NSManagedObject{
    @NSManaged var currentRadius:Double
}
