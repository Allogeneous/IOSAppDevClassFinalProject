//
//  ViewController.swift
//  LocalExplorer
//
//  Created by Joshua Marriott on 4/4/19.
//  Copyright © 2019 Joshua Marriott. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITableViewDataSource, CLLocationManagerDelegate{
    
    

    @IBOutlet weak var locationTableView: UITableView!
    
    var lwLocationManager:LWLocationManager = LWLocationManager()
    var clLocationManager:CLLocationManager = CLLocationManager()
    var lwDataManager:LWDataManager = LWDataManager()
    var currentSession:LWSession!

    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        locationTableView.dataSource = self
        clLocationManager.delegate = self
        //lwDataManager.clearStoredLWLocationData()
        lwDataManager.loadLWLocationDataObjects()
        lwDataManager.loadLWSettings()
        
        currentSession = LWSession(lwLocationManager: lwLocationManager, lwSearchResult: LWSearchResult(name: "", lat: 0, lon:0, empty: true), isValid: false, arrived: false)
    
        
        if CLLocationManager.locationServicesEnabled() == true {
            
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied ||  CLLocationManager.authorizationStatus() == .notDetermined {
                clLocationManager.requestWhenInUseAuthorization()
            }
            clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
            clLocationManager.startUpdatingLocation()
        } else {
            print("Please turn on location services or GPS")
        }
        
 
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onAddClick(_ sender: Any) {
        let alert = UIAlertController(title: "Enter a Keyword", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "coffee"
        })
        
        alert.addAction(UIAlertAction(title: "Start", style: .default, handler: { action in
            
            if let searchTerm = alert.textFields?.first?.text {
                if(searchTerm.contains(" ")){
                    alert.dismiss(animated: true, completion: nil)
                    let warning = UIAlertController(title: "Field must only have one word!", message: nil, preferredStyle: .alert)
                    warning.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(warning, animated: true)
                }else{
                    self.lwLocationManager.searchWithRandomResult(radius: self.lwDataManager.settings.currentRadius, keyword: searchTerm, completion: { finished in
                        if(finished.isEmpty()){
                            let warning = UIAlertController(title: "Could not find any locations, try again!", message: nil, preferredStyle: .alert)
                            warning.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(warning, animated: true)
                        }else{
                            DispatchQueue.main.async(execute: {
                                self.currentSession = LWSession(lwLocationManager: self.lwLocationManager, lwSearchResult: finished, isValid: true, arrived: false)
                                self.performSegue(withIdentifier: "tableToMap", sender: self)
                            })
                            
                        }
                    })
                }
                
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lwDataManager.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") as! LocationTableViewCell
        cell.nameLabel.text = lwDataManager.locations[indexPath.row].name
        cell.previewImage.image = lwDataManager.locations[indexPath.row].image
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        
        lwDataManager.deleteLWLocation(index: indexPath.row)
        
        tableView.reloadData()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            clLocationManager.requestLocation()
        }
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            lwLocationManager.currentLat = clLocationManager.location!.coordinate.latitude
            lwLocationManager.currentLon = clLocationManager.location!.coordinate.longitude
            
            //print(lwLocationManager.currentLat)
            //print(lwLocationManager.currentLon)
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == "tableToMap" && self.currentSession.isValid == true){
            return true
        }
        if(identifier == "tableToSettings"){
            return true
        }
        if(identifier == "cellToLocation"){
            return true
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "tableToMap"){
            if let viewController: MapViewController = segue.destination as? MapViewController {
                viewController.currentSession = self.currentSession
                viewController.currentLWSettings = self.lwDataManager.settings
            }
        }
        if(segue.identifier == "tableToSettings"){
            if let viewController: SettingsViewController = segue.destination as? SettingsViewController {
                viewController.radius = self.lwDataManager.settings.currentRadius
            }
        }
        if(segue.identifier == "cellToLocation"){
            if let viewController: LocationViewController = segue.destination as? LocationViewController {
                let selectedIndex: IndexPath = self.tableView.indexPath(for: sender as! LocationTableViewCell)!
                viewController.index = selectedIndex.row
                viewController.lwLocationData = lwDataManager.locations[selectedIndex.row]
            }
        }
    }
    
    @IBAction func didUnwindFromMapInvalidate(_ segue: UIStoryboardSegue){
        if let viewController: MapViewController = segue.source as? MapViewController {
            viewController.timer.invalidate()
            self.currentSession = viewController.currentSession
            self.currentSession.isValid = false
        }
    }
    
    @IBAction func didUnwindFromMapValidate(_ segue: UIStoryboardSegue){
        if let viewController: MapViewController = segue.source as? MapViewController {
            viewController.timer.invalidate()
            self.currentSession = viewController.currentSession
        }
    }

    
    @IBAction func didUnwindFromSettings(_ segue: UIStoryboardSegue){
        if let viewController: SettingsViewController = segue.source as? SettingsViewController {
            if(!CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: viewController.radiusField.text!))){
                viewController.radiusField.text! = "\(lwDataManager.settings.currentRadius)"
            }else{
                let newRadius = Double(viewController.radiusField.text!)!
                
                if(newRadius >= lwDataManager.settings.geMinRadius() && newRadius < lwDataManager.settings.getMaxRadius()){
                    let newSettings = LWSettings()
                    newSettings.currentRadius = newRadius
                    lwDataManager.updateSettings(settings: newSettings)
                }else{
                    viewController.radiusField.text! = "\(lwDataManager.settings.currentRadius)"
                }
            }
        }
        
    }
    
    @IBAction func didUnwindFromLocation(_ segue: UIStoryboardSegue){
        if let viewController: LocationViewController = segue.source as? LocationViewController {
            if(viewController.currentSession != nil){
                self.currentSession = viewController.currentSession
                let newLocation:LWLocationData = LWLocationData(name: viewController.nameField.text!, description: viewController.descriptionField.text!, image: viewController.imageView.image!, uuid: viewController.lwLocationData!.uuid)
                lwDataManager.addLWLocationData(location: newLocation)
                tableView.reloadData()
            }else{
                let newLocation:LWLocationData = LWLocationData(name: viewController.nameField.text!, description: viewController.descriptionField.text!, image: viewController.imageView.image!, uuid: viewController.lwLocationData!.uuid)
                lwDataManager.replaceLWLocationData(locaton: newLocation, index: viewController.index!)
                tableView.reloadData()
            }
        }
    }
}

