//
//  LocationManager.swift
//  RemindMe
//
//  Created by Garrett Votaw on 5/26/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationError: Error {
    case unknownError
    case disallowedByUser
    case unableToFindLocation
}

protocol LocationManagerDelegate: class {
    func obtainedCoordinates(_ location: CLLocation)
    func failedWithError(_ error: LocationError)
    func didChangeAuthorizationStatus(_ status: CLAuthorizationStatus)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    weak var locationDelegate: LocationManagerDelegate?
    
    init(locationDelegate: LocationManagerDelegate) {
        self.locationDelegate = locationDelegate
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startMonitoring(_ region: CLRegion) {
        manager.startMonitoring(for: region)
    }
    
    func stopMonitoring(_ region: CLRegion) {
        manager.stopMonitoring(for: region)
    }
    
    func requestWhenInUseAuthorization() throws {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .restricted || authorizationStatus == .denied {
            throw LocationError.disallowedByUser
        } else if authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else {
            return
        }
    }
    
    func requestAlwaysAuthorization() throws {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .restricted || authorizationStatus == .denied {
            throw LocationError.disallowedByUser
        } else if authorizationStatus == .authorizedWhenInUse {
            manager.requestAlwaysAuthorization()
        }
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else {
            locationDelegate?.failedWithError(.unknownError)
            return
        }
        
        switch error.code {
        case .locationUnknown, .network: locationDelegate?.failedWithError(.unableToFindLocation)
        case .denied: locationDelegate?.failedWithError(.disallowedByUser); manager.stopUpdatingLocation()
        default: print(error.code)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            locationDelegate?.failedWithError(.unableToFindLocation)
            return
        }
        locationDelegate?.obtainedCoordinates(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationDelegate?.didChangeAuthorizationStatus(status)
    }
    
}








struct Coordinate {
    let longitude: Double
    let latitude: Double
}

extension Coordinate {
    init(location: CLLocation) {
        self.longitude = location.coordinate.longitude
        self.latitude = location.coordinate.latitude
    }
}
