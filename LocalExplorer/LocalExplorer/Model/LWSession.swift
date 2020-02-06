//
//  LWSession.swift
//  LocalExplorer
//
//  Created by Joshua Marriott on 4/8/19.
//  Copyright © 2019 Joshua Marriott. All rights reserved.
//

import Foundation

public class LWSession{
    
    var lwLocationManager:LWLocationManager
    var lwSearchResult:LWSearchResult
    var isValid:Bool
    var arrived:Bool
    
    init(lwLocationManager:LWLocationManager, lwSearchResult:LWSearchResult, isValid:Bool, arrived:Bool){
        self.lwLocationManager = lwLocationManager
        self.lwSearchResult = lwSearchResult
        self.isValid = isValid
        self.arrived = arrived
    }
}
