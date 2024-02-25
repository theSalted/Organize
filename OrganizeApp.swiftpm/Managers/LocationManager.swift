//
//  LocationManager.swift
//  Organize
//
//  Created by Yuhao Chen on 2/23/24.
//

import Foundation
import CoreLocation
import Observation
import OSLog

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    var location: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        manager.startUpdatingLocation()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        logger.warning("CLLocationManagerDelegate failed: \(error.localizedDescription)")
    }
}

fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "LocationManager")
