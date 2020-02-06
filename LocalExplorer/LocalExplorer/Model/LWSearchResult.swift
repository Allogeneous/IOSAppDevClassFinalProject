//
//  LWSearchResult.swift
//  LocalExplorer
//
//  Created by Joshua Marriott on 4/4/19.
//  Copyright © 2019 Joshua Marriott. All rights reserved.
//

import Foundation

public class LWSearchResult{
    
    private let name:String
    private let lat:Double
    private let lon:Double
    private let empty:Bool
    
    init(name:String, lat:Double, lon:Double, empty:Bool){
        self.name = name
        self.lat = lat
        self.lon = lon
        self.empty = empty
    }
    
    func getName() -> (String){
        return name
    }
    
    func getLat() -> (Double){
        return lat
    }
    
    func getLon() -> (Double){
        return lon
    }
    
    func isEmpty() -> (Bool){
        return empty
    }
}
