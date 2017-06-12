//
//  Geolocation.swift
//  SampleTest
//
//  Created by Hildequias Junior on 6/12/17.
//  Copyright © 2017 Pixonsoft. All rights reserved.
//

import UIKit
import CoreLocation

struct GeoKey {
    static let device = "device"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let identifier = "identifier"
    static let date = "date"
}

class Geolocation: NSObject, NSCoding {

    var device: String
    var latitude: Double
    var longitude: Double
    var identifier: String
    var date: Date
    
    init(coordinate: CLLocationCoordinate2D, identifier: String, date: Date) {
        
        self.device = (UIDevice.current.identifierForVendor?.uuidString)!
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.identifier = identifier
        self.date = date
    }
    
    // MARK: NSCoding
    required init?(coder decoder: NSCoder) {
        
        device = decoder.decodeObject(forKey: GeoKey.device) as! String
        latitude = decoder.decodeDouble(forKey: GeoKey.latitude)
        longitude = decoder.decodeDouble(forKey: GeoKey.longitude)
        identifier = decoder.decodeObject(forKey: GeoKey.identifier) as! String
        date = decoder.decodeObject(forKey: GeoKey.date) as! Date
    }
    
    func encode(with coder: NSCoder) {
        
        coder.encode(device, forKey: GeoKey.device)
        coder.encode(latitude, forKey: GeoKey.latitude)
        coder.encode(longitude, forKey: GeoKey.longitude)
        coder.encode(identifier, forKey: GeoKey.identifier)
        coder.encode(date, forKey: GeoKey.date)
    }
}
