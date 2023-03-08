//
//  LocationService .swift
//  Mprayer
//
//  Created by Mac on 12/27/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
 
import CoreLocation

protocol LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: NSError)
}

class LocationSingleton: NSObject,CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    static let shared:LocationSingleton = {
        let instance = LocationSingleton()
        return instance
    }()
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        
        guard let locationManagers=self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManagers.requestAlwaysAuthorization()
            locationManagers.requestWhenInUseAuthorization()
        }
        if #available(iOS 9.0, *) {
            //            locationManagers.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
        locationManagers.desiredAccuracy = kCLLocationAccuracyBest
        locationManagers.pausesLocationUpdatesAutomatically = false
        locationManagers.distanceFilter = 0.1
        locationManagers.delegate = self
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    var start = true
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        manager.stopUpdatingLocation()
        self.lastLocation = location
        updateLocation(currentLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager?.requestAlwaysAuthorization() 
            break
        case .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
              NotificationCenter.default.post(name: NSNotification.Name("LocationAccessed"), object:nil)
            break
        case .authorizedAlways:
            locationManager?.startUpdatingLocation()
            NotificationCenter.default.post(name: NSNotification.Name("LocationAccessed"), object:nil)
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            print("restrictedrestrictedrestrictedrestricted")
            NotificationCenter.default.post(name: NSNotification.Name("LocationAccessed"), object:nil)
            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            NotificationCenter.default.post(name: NSNotification.Name("LocationAccessed"), object:nil)
            //  print("denieddenieddenieddenieddenieddenieddenied")
            break
 
        default:
            break
        }
    }
      
    // Private function
    private func updateLocation(currentLocation: CLLocation){
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: NSError) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(error: error)
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
        //        self.locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    func startMonitoringSignificantLocationChanges() {
        self.locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    // #MARK:   get the alarm time from date and time
}
