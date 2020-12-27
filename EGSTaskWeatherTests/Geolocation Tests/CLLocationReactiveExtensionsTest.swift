//
//  CoreLocationManagerTests.swift
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

class CLLocationReactiveExtensionsTest: XCTestCase {
        
    func testDidUpdateLocations() {
        var location: CLLocation?
        
        let targetLocation = CLLocation(latitude: 40, longitude: 120)
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        let manager = CLLocationManager()
        _ = manager.rx.didUpdateLocations.subscribe(onNext: { (locations) in
            location = locations[0]
            expectation.fulfill()
            
        })
        manager.delegate!.locationManager!(manager, didUpdateLocations: [targetLocation])
        self.wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(location?.coordinate.latitude, targetLocation.coordinate.latitude)
        XCTAssertEqual(location?.coordinate.longitude, targetLocation.coordinate.longitude)
        
    }
    
    func testDidFailWithError() {
        var error: Error?
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        let manager = CLLocationManager()
        
        _ = manager.rx.didFailWithError.subscribe(onNext: { value in
            error = value
            expectation.fulfill()
        })
        manager.delegate!.locationManager!(manager, didFailWithError: RxError.unknown)
        
        
        self.wait(for: [expectation], timeout: 1)
        
        XCTAssertNotNil(error)
        
    }
    
    
}

