//
//  GeoLocationMock.swift
//  EGSTaskWeatherTests
//
//  Created by Dose on 12/26/20.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation
@testable import EGSTaskWeather
import XCTest

final class GeoLocationMock: GeolocationProtocol {
    
    private(set) var authorized: Driver<Bool>
    private(set) var location: Driver<CLLocationCoordinate2D>
    private(set) var locationManager: CLLocationManager
    private(set) var placemarks: Driver<CLPlacemark?>

    init(locationManager: CLLocationManager = CLLocationManager(), targetLocation: CLLocationCoordinate2D? = nil) {
        self.locationManager = locationManager
        
        
        authorized = locationManager.rx.didUpdateAuthorizationStatus.startWith(CLLocationManager.authorizationStatus()).asDriver(onErrorJustReturn: .notDetermined).map({ (status) -> Bool in
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

        location = locationManager.rx
            .didUpdateLocations.asDriver(onErrorJustReturn: []).flatMap {
                $0.last.map(Driver.just) ?? Driver.empty()
            }.map { value in
                return value.coordinate
            }
        
        placemarks = Observable.create { (observer) -> Disposable in
            if let targetLocation = targetLocation {
                CLGeocoder().rx.base.reverseGeocodeLocation(CLLocation(latitude: targetLocation.latitude, longitude: targetLocation.longitude), completionHandler: { placemark, error in
                    observer.onNext(placemark?.first)
                })
                
            } else {
                observer.onError(RxError.noElements)
            }

            return Disposables.create ()
            }.asDriver(onErrorJustReturn: nil)
    }
    
    
}
