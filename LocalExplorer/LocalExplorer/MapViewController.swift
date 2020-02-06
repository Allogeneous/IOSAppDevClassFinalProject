//
//  MapViewController.swift
//  LocalExplorer
//
//  Created by Joshua Marriott on 4/8/19.
//  Copyright © 2019 Joshua Marriott. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    let offset = 0.001125;
    
    var currentSession:LWSession?
    var currentLWSettings:LWSettings?
    
    var locPos = MKPointAnnotation()
    var userPos = MKPointAnnotation()
    
    @IBOutlet weak var mapView: MKMapView!
    
    var timer = Timer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coord = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: (currentSession?.lwLocationManager.currentLat)!)!, longitude: CLLocationDegrees(exactly: (currentSession?.lwLocationManager.currentLon)!)!)
        let region = MKCoordinateRegion(center: coord, latitudinalMeters: CLLocationDistance(exactly: currentLWSettings!.currentRadius * 2)!, longitudinalMeters: CLLocationDistance(exactly: currentLWSettings!.currentRadius * 2)!)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        
        locPos.coordinate.latitude = currentSession!.lwSearchResult.getLat()
        locPos.coordinate.longitude = currentSession!.lwSearchResult.getLon()
        
        locPos.subtitle = currentSession!.lwSearchResult.getName()
        
        //print(locPos.coordinate.latitude)
        //print(locPos.coordinate.longitude)
        
        self.mapView.addAnnotation(locPos)
        
        userPos.coordinate.latitude = currentSession!.lwLocationManager.currentLat
        userPos.coordinate.longitude = currentSession!.lwLocationManager.currentLon
        
        userPos.subtitle = "You"
        
        //print(userPos.coordinate.latitude)
        //print(userPos.coordinate.longitude)
        
        self.mapView.addAnnotation(userPos)
        
        scheduledUserLocationUpdateAndCheck()
    }
    
    func scheduledUserLocationUpdateAndCheck(){
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateAndCheckLocation), userInfo: nil, repeats: true)
    }
    
    @objc func updateAndCheckLocation(){
        
        userPos.coordinate.latitude = currentSession!.lwLocationManager.currentLat
        userPos.coordinate.longitude = currentSession!.lwLocationManager.currentLon
        
        //userPos.coordinate.latitude = locPos.coordinate.latitude - 0.0001
        //userPos.coordinate.longitude = locPos.coordinate.longitude + 0.0001
        
        let latBig = locPos.coordinate.latitude + offset
        let latSmall = locPos.coordinate.latitude - offset
        
        let lonBig = locPos.coordinate.longitude + offset
        let lonSmall = locPos.coordinate.longitude - offset
        
        if(self.currentSession!.arrived == false && userPos.coordinate.latitude > latSmall && userPos.coordinate.latitude < latBig && userPos.coordinate.longitude > lonSmall && userPos.coordinate.longitude < lonBig){
            self.currentSession!.isValid = false
            self.currentSession!.arrived = true
            
            let arrived = UIAlertController(title: "You have arrived at your destination!", message: nil, preferredStyle: .alert)
            arrived.addAction(UIAlertAction(title: "Add to List", style: .default, handler: {  action in
                    self.performSegue(withIdentifier: "mapToLocation", sender: self)
                }
            ))
            self.present(arrived, animated: true)
            
            self.timer.invalidate()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mapToLocation"){
            if let viewController: LocationViewController = segue.destination as? LocationViewController {
                viewController.currentSession = self.currentSession
            }
        }
    }
    

}
