//
//  LWDataManager.swift
//  LocalExplorer
//
//  Created by Joshua Marriott on 4/11/19.
//  Copyright © 2019 Joshua Marriott. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class LWDataManager{
    let insertContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    let viewContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    
    var locations: [LWLocationData] = []
    var settings:LWSettings = LWSettings()
    
    func clearStoredSettings() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredLWSettings")
        // performs the batch delete for the contact
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
            
            
        }
        catch let _ as NSError {
            // Handle error
        }
        
    }
    
    func clearStoredLWLocationData() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredLWLocationData")
        // performs the batch delete for the contact
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
            
            
        }
        catch let _ as NSError {
            // Handle error
        }
        
    }

    
    public func addLWLocationData(location: LWLocationData) {
        
        // get a handler to the Contacts entity through the managed object context
        let ent = NSEntityDescription.entity(forEntityName: "StoredLWLocationData", in: self.viewContext)
        
        // create a contact object instance for insert
        let storedData = StoredLWLocationData(entity: ent!, insertInto: self.viewContext)
        
        
        // add data to each field in the entity
        
        
        storedData.name = location.name
        storedData.descriptionString = location.description
        storedData.image = location.image.pngData()
        storedData.uuid = location.uuid
        
        
        
        // save the new entity
        do {
            try viewContext.save()
            
        } catch let error {
            //status.text = error.localizedDescription
            
        }
        
        locations.append(location)
        //cityTableView.reloadData()
    }
    
    private func addLWSettings(settings: LWSettings) {
        
        // get a handler to the Contacts entity through the managed object context
        let ent = NSEntityDescription.entity(forEntityName: "StoredLWSettings", in: self.viewContext)
        
        // create a contact object instance for insert
        let storedData = StoredLWSettings(entity: ent!, insertInto: self.viewContext)
        
        
        // add data to each field in the entity
        
        
        storedData.currentRadius = settings.currentRadius
        
        
        
        // save the new entity
        do {
            try viewContext.save()
            
        } catch let error {
            //status.text = error.localizedDescription
            
        }
        
        //cityList.append(city)
        //cityTableView.reloadData()
    }
    
    public func updateSettings(settings: LWSettings){
        clearStoredSettings()
        addLWSettings(settings: settings)
        self.settings = settings
    }
    
    public func replaceLWLocationData(locaton: LWLocationData, index: Int) {
        deleteLWLocation(index: index)
        addLWLocationData(location: locaton)
        
    }
    
    public func loadLWLocationDataObjects(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredLWLocationData")
        
        if  let fetchResults = (try? viewContext.fetch(fetchRequest)) as? [StoredLWLocationData]{
            
            let x = fetchResults.count
            
            
            //print(x)
            if x != 0 {
                for i in 0..<x {
                    let l = fetchResults[i]
                    let lwLocation : LWLocationData = LWLocationData()
                    
                    lwLocation.name = l.name!
                    lwLocation.description = l.descriptionString!
                    lwLocation.image = UIImage(data: l.image! as Data)!
                    lwLocation.uuid = l.uuid!
                    
                    locations.append(lwLocation)
                    
                }
                
                
            }
            
        }
    }
    
    public func loadLWSettings(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredLWSettings")
        
        if  let fetchResults = (try? viewContext.fetch(fetchRequest)) as? [StoredLWSettings]{
            
            let x = fetchResults.count
            
            
            //print(x)
            if x != 0 {
                
                let s = fetchResults[0]
                let lwSettings : LWSettings = LWSettings()
                    
                lwSettings.currentRadius = s.currentRadius
                
                    
                self.settings = lwSettings
                
            }
            
        }
    }
    
    public func deleteLWLocation(index: Int){
        let uuid:String = locations[index].uuid
        locations.remove(at: index)
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredLWLocationData")
        
        if  let fetchResults = (try? viewContext.fetch(fetchRequest)) as? [StoredLWLocationData]{
            
            let x = fetchResults.count
            
            if x != 0 {
                for i in 0..<x {
                    let l = fetchResults[i]
                    
                    if(l.uuid == uuid){
                        viewContext.delete(l)
                        do {
                            try viewContext.save()
                            
                        } catch let error {
                            //status.text = error.localizedDescription
                        }
                        break
                    }
                    
                }
                
                
            }
            
        }
    }
}
