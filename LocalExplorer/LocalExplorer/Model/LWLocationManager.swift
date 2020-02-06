//
//  JsonManager.swift
//  LocalExplorer
//
//  Created by Joshua Marriott on 4/4/19.
//  Copyright © 2019 Joshua Marriott. All rights reserved.
//

import Foundation
import MapKit

public class LWLocationManager {


    var currentLat:Double
    var currentLon:Double

    init(){
        currentLat = 0
        currentLon = 0
    }

    func searchWithRandomResult(radius:Double, keyword:String, completion: @escaping (_ finished: LWSearchResult) -> ()){
        let urlAsString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(currentLat),\(currentLon)&radius=\(radius)&name=\(keyword)&key=API_KEY_HERE"

        let url = URL(string: urlAsString)!
        let urlSession = URLSession.shared

        var searchResult = LWSearchResult(name: "", lat: 0, lon: 0, empty: true)

        let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            var err: NSError?


            var jsonResult = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
            if (err != nil) {
                print("JSON Error \(err!.localizedDescription)")
            }

            //print(jsonResult)


            let results:NSArray = jsonResult["results"] as! NSArray

            if(results.count == 0){
                searchResult = LWSearchResult(name: "", lat: 0, lon:0, empty: true)
            }else{
                let number = Int.random(in: 0 ..< results.count)
                let locationData = results[number]

                let location = locationData as? [String: AnyObject]

                let name = location?["name"] as? String

                let geometry = location?["geometry"] as? [String: AnyObject]
                let coords = geometry?["location"] as? [String: AnyObject]

                let lat = coords?["lat"] as? Double
                let lon = coords?["lng"] as? Double

                searchResult = LWSearchResult(name: name!, lat: lat!, lon: lon!, empty: false)

            }
            completion(searchResult)
        })

        jsonQuery.resume()

    }




}
