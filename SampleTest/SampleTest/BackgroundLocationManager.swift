//
//  BackgroundLocationManager.swift
//  SampleTest
//
//  Created by Hildequias Junior on 6/12/17.
//  Copyright © 2017 Pixonsoft. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

struct PreferencesKeys {
    static let savedItems = "savedItems"
}

class BackgroundLocationManager :NSObject, CLLocationManagerDelegate {
    
    static let instance = BackgroundLocationManager()
    static let BACKGROUND_TIMER = 10.0 // restart location manager every 150 seconds
    static let UPDATE_SERVER_INTERVAL = 5 // 1 hour - once every 1 hour send location to server
    
    let locationManager = CLLocationManager()
    var timer:Timer?
    var currentBgTaskId : UIBackgroundTaskIdentifier?
    var lastLocationDate : NSDate = NSDate()
    
    var geolocations: [Geolocation] = []
    
    private override init(){
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.activityType = .other;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        if #available(iOS 9, *){
            locationManager.allowsBackgroundLocationUpdates = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    func applicationEnterBackground(){
        debugPrint("applicationEnterBackground")
        start()
    }
    
    func start(){
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            if #available(iOS 9, *){
                locationManager.requestLocation()
            } else {
                locationManager.startUpdatingLocation()
            }
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func restart (){
        
        timer?.invalidate()
        timer = nil
        start()
    }
    
    func stop() {
        
        timer?.invalidate()
        timer = nil
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.restricted: break
        //log("Restricted Access to location")
        case CLAuthorizationStatus.denied: break
        //log("User denied access to location")
        case CLAuthorizationStatus.notDetermined: break
        //log("Status not determined")
        default:
            //log("startUpdatintLocation")
            if #available(iOS 9, *){
                locationManager.requestLocation()
            } else {
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if(timer==nil){
            // The locations array is sorted in chronologically ascending order, so the
            // last element is the most recent
            guard locations.last != nil else {return}
            
            beginNewBackgroundTask()
            locationManager.stopUpdatingLocation()
            let now = NSDate()
            if(isItTime(now: now)){
                //TODO: Every n minutes do whatever you want with the new location. Like for example
                self.sendLocationToServer(location: manager.location!, now:now)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error)
        
        beginNewBackgroundTask()
        locationManager.stopUpdatingLocation()
    }
    
    func isItTime(now:NSDate) -> Bool {
        let timePast = now.timeIntervalSince(lastLocationDate as Date)
        let intervalExceeded = Int(timePast) > BackgroundLocationManager.UPDATE_SERVER_INTERVAL
        return intervalExceeded;
    }
    
    func sendLocationToServer(location:CLLocation, now:NSDate){
        //TODO
        
        let locValue:CLLocationCoordinate2D = location.coordinate
        let coordinate = location.coordinate
        let identifier = NSUUID().uuidString
        let date = Date()
        let geo = Geolocation(coordinate: coordinate, identifier: identifier, date: date)
        
        self.add(geo: geo)
        
        print("New Coordinates: LAT= \(locValue.latitude) LON= \(locValue.longitude)")
    }
    
    func beginNewBackgroundTask(){
        var previousTaskId = currentBgTaskId;
        currentBgTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            debugPrint("task expired: ")
        })
        if let taskId = previousTaskId{
            UIApplication.shared.endBackgroundTask(taskId)
            previousTaskId = UIBackgroundTaskInvalid
        }
        
        timer = Timer.scheduledTimer(timeInterval: BackgroundLocationManager.BACKGROUND_TIMER, target: self, selector: #selector(self.restart),userInfo: nil, repeats: false)
    }
    
    // MARK: Functions that update the model/associated views with Geolocation changes
    func add(geo: Geolocation) {
        geolocations.append(geo)
        saveAllGeotifications()
    }
    
    // MARK: Loading and saving functions
    func loadAllGeotifications() {
        geolocations = []
        guard let savedItems = UserDefaults.standard.array(forKey: PreferencesKeys.savedItems) else { return }
        for savedItem in savedItems {
            guard let geotification = NSKeyedUnarchiver.unarchiveObject(with: savedItem as! Data) as? Geolocation else { continue }
            self.add(geo: geotification)
        }
    }
    
    func saveAllGeotifications() {
        var items: [Data] = []
        for geo in geolocations {
            let item = NSKeyedArchiver.archivedData(withRootObject: geo)
            items.append(item)
        }
        UserDefaults.standard.set(items, forKey: PreferencesKeys.savedItems)
    }
}
