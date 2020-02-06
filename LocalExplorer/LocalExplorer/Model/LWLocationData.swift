//
//  LWLocationData.swift
//  LocalExplorer
//
//  Created by Joshua Marriott on 4/11/19.
//  Copyright © 2019 Joshua Marriott. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class LWLocationData {

    var name:String
    var description:String
    var image:UIImage
    var uuid:String
    
    init(){
        name = ""
        description = ""
        image = UIImage(named: "default.png")!
        uuid = UUID().uuidString
    }
    
    init(name:String, description:String, image:UIImage, uuid:String){
        self.name = name
        self.description = description
        self.image = image
        self.uuid = uuid
    }
    
    

}

class StoredLWLocationData : NSManagedObject{
    @NSManaged var name:String?
    @NSManaged var descriptionString:String?
    @NSManaged var image:Data?
    @NSManaged var uuid:String?
}



