//
//  Utils.swift
//  SampleTest
//
//  Created by Hildequias Junior on 6/12/17.
//  Copyright © 2017 Pixonsoft. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    func createJSON(geolocation:[Geolocation]) -> String {
        
        let list:NSMutableArray = NSMutableArray()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        
        for geo in geolocation
        {
            let geolocation: NSMutableDictionary = NSMutableDictionary()
            
            geolocation.setValue(geo.device, forKey: GeoKey.device)
            geolocation.setValue(geo.latitude, forKey: GeoKey.latitude)
            geolocation.setValue(geo.longitude, forKey: GeoKey.longitude)
            geolocation.setValue(geo.identifier, forKey: GeoKey.identifier)
            geolocation.setValue(dateFormatter.string(from: geo.date), forKey: GeoKey.date)
            
            list.add(geolocation)
        }
        
        do {
            
            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: list, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            //Do this for print data only otherwise skip
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                
                return JSONString
            }
        } catch {
            print(error)
        }
        return ""
    }
    
    
}
