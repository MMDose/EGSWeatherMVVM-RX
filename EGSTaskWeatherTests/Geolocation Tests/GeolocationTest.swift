//
//  GeolocationTest.swift
//  EGSTaskWeatherTests
//
//  Created by Dose on 12/26/20.
//

import RxSwift
import RxTest
import RxCocoa
import CoreLocation

@testable import EGSTaskWeather
import XCTest

class GeoLocationServiceTests: XCTestCase {
    
    func testGeolocationServiceAuthorizationStatusAuthorized() {
        let expectation = XCTestExpectation()
        let authorizationStatus = CLAuthorizationStatus.authorizedAlways
        let isAuthorized: Bool = true
        var receivedAuthorizationStatus: Bool?
        
        expectation.expectedFulfillmentCount = 1
        let locationManager = CLLocationManager()
        let geolocation: GeolocationProtocol = GeolocationService(locationManager: locationManager)
        _ = geolocation.authorized.skip(1).drive (onNext: { (value) in
            // After invnking didChangeAuthrizationStatus system automaticly calls again with state notDetermined. In that case we just need to test first received value.
            if receivedAuthorizationStatus == nil {
                receivedAuthorizationStatus = value
                expectation.fulfill()
            }
        })
        locationManager.delegate!.locationManager!(locationManager, didChangeAuthorization: authorizationStatus)
        
        self.wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(isAuthorized, receivedAuthorizationStatus)
    }
    
    
    func testGeolocationServiceAuthorizationStatusNotDetermined() {
        let expectation = XCTestExpectation()
        let authorizationStatus = CLAuthorizationStatus.notDetermined
        let isAuthorized: Bool = true
        var receivedAuthorizationStatus: Bool?
        
        expectation.expectedFulfillmentCount = 1
        
        let locationManager = CLLocationManager()
        
        let geolocation: GeolocationProtocol = GeolocationService(locationManager: locationManager)
        
        _ = geolocation.authorized.skip(1).drive (onNext: { (value) in
            // After invnking didChangeAuthrizationStatus system automaticly calls again with state notDetermined. In that case we just need to test first received value.
            if receivedAuthorizationStatus == nil {
                receivedAuthorizationStatus = value
                expectation.fulfill()
            }
        })
        locationManager.delegate!.locationManager!(locationManager, didChangeAuthorization: authorizationStatus)
        
        
        
        self.wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(isAuthorized, receivedAuthorizationStatus)
    }
    
    func testGeolocationServiceAuthorizationStatusDenied() {
        let expectation = XCTestExpectation()
        let authorizationStatus = CLAuthorizationStatus.denied
        let isAuthorized: Bool = false
        var receivedAuthorizationStatus: Bool?
        
        expectation.expectedFulfillmentCount = 1
        
        let locationManager = CLLocationManager()
        let geolocation: GeolocationProtocol = GeolocationService(locationManager: locationManager)
        
        _ = geolocation.authorized.skip(1).drive (onNext: { (value) in
            // After invnking didChangeAuthrizationStatus system automaticly calls again with state notDetermined. In that case we just need to test first received value.
            if receivedAuthorizationStatus == nil {
                receivedAuthorizationStatus = value
                expectation.fulfill()
            }
        })
        locationManager.delegate!.locationManager!(locationManager, didChangeAuthorization: authorizationStatus)
        
        
        
        self.wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(isAuthorized, receivedAuthorizationStatus)
    }
    
    func testGeolocationServiceLocation() {
        let expectation = XCTestExpectation()
        let targetLocation = CLLocation(latitude: 40, longitude: 80)
        var receivedLocationCoordinates: CLLocationCoordinate2D?
        
        expectation.expectedFulfillmentCount = 1
        
        let locationManager = CLLocationManager()
        
        let geolocation: GeolocationProtocol = GeolocationService(locationManager: locationManager)
        
        _ = geolocation.location.drive (onNext: { (value) in
            receivedLocationCoordinates = value
            expectation.fulfill()
        })
        locationManager.delegate!.locationManager!(locationManager, didUpdateLocations: [targetLocation])
        
        
        self.wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(targetLocation.coordinate.latitude, receivedLocationCoordinates?.latitude)
        XCTAssertEqual(targetLocation.coordinate.longitude, receivedLocationCoordinates?.longitude)
        
    }
    
    func testGeolocationServiceGeocoder() {
        // For geolocation protocol its required that device should be connected to network oterwise test will failure.

        let expectation = XCTestExpectation()
        let targetLocation = CLLocation(latitude: 40.177200, longitude: 44.503490)
        let targetLocality: String = "Yerevan"
        var receivedLocality: String?
        expectation.expectedFulfillmentCount = 1

        autoreleasepool {
            let locationManager = CLLocationManager()

            let geolocation: GeolocationProtocol = GeolocationService(locationManager: locationManager)
            _ = geolocation.placemarks.drive (onNext: { (value) in
                receivedLocality = value?.locality
                expectation.fulfill()
            })
            locationManager.delegate!.locationManager!(locationManager, didUpdateLocations: [targetLocation])

        }
        
        
        self.wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(targetLocality, receivedLocality)
        
    }
    
    
}
