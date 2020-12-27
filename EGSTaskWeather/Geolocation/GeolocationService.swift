//
//  GeolocationService.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/25/20.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation


// MARK: - Geolocation Protocol

public protocol GeolocationProtocol {
    var authorized: Driver<Bool> { get }
    var location: Driver<CLLocationCoordinate2D> { get }
    var locationManager: CLLocationManager { get }
    var placemarks: Driver<CLPlacemark?> { get }
}


//MARK: - GeolocationService

final class GeolocationService: GeolocationProtocol {
    
    private(set) var authorized: Driver<Bool>
    private(set) var location: Driver<CLLocationCoordinate2D>
    private(set) var locationManager: CLLocationManager
    private(set) var placemarks: Driver<CLPlacemark?>
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        // Starts observing location authorization status.
        authorized = locationManager.rx.didUpdateAuthorizationStatus.startWith(CLLocationManager.authorizationStatus()).asDriver(onErrorJustReturn: .notDetermined).map({ (status) in
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
                return true
            default: return false
            }
        })
        //Starts observing locations.
        location = locationManager.rx
            .didUpdateLocations.asDriver(onErrorJustReturn: []).flatMap {
                $0.last.map(Driver.just) ?? Driver.empty()
            }.map {
                $0.coordinate
            }
        //Starts observing placemarks. 
        placemarks = location.flatMapLatest { location in
        
            return Observable.create { (observer) -> Disposable in
                
                CLGeocoder().rx.base.reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude), completionHandler: { placemark, error in
                    observer.onNext(placemark?.first)
                })
                
                return Disposables.create()
            }.asDriver(onErrorJustReturn: nil)

        }
    
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func startObservingLocations() {
        
    }
}

