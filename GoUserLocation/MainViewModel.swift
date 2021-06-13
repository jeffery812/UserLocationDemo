//
//  MainViewModel.swift
//  GoUserLocation
//
//  Created by Zhihui Tang on 2021/06/13.
//

import Combine
import MapKit
import CoreData
import CoreLocation

class MainViewModel: NSObject, ObservableObject {
    @Published var permissionDenied = false
    @Published var region = MKCoordinateRegion()
    
    private var managedObjectContext: NSManagedObjectContext?
    private var locationManager = CLLocationManager()
    
    func setup(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.allowsBackgroundLocationUpdates = true
    }

    func startLocationServices() {
        guard locationManager.authorizationStatus == .authorizedAlways else {
            locationManager.requestAlwaysAuthorization()
            return
        }
        locationManager.startUpdatingLocation()
    }
}

extension MainViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied, .restricted:
            permissionDenied = true
        case .notDetermined:
            break
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let clError = error as? CLError else { return }
        switch clError {
        case CLError.denied:
            print("Access denied")
        default:
            print("didFailWithError: \(String(describing: error))")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
}
