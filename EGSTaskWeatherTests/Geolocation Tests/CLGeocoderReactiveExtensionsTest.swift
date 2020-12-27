//
//  CLGeocoderReactiveExtensionsTest.swift
//  EGSTaskWeatherTests
//
//  Created by Dose on 12/26/20.
//

import UIKit
import RxSwift
import RxTest
import RxCocoa
import CoreLocation

@testable import EGSTaskWeather
import XCTest

class CLGeocoderReactiveExtensionsTest: XCTestCase {
    
    func testReverseGeocoderLocation() {
        // For geolocation protocol its required that device should be connected to network oterwise test will failure.

        let expectation = XCTestExpectation()
        let targetLocation = CLLocation(latitude: 40.177200, longitude: 44.503490)
        let targetLocality: String = "Yerevan"
        var receivedLocality: String?
        expectation.expectedFulfillmentCount = 1

        autoreleasepool {
            _ = CLGeocoder().rx.reverseGeocoderLocation(targetLocation).subscribe(onNext: { (value) in
                receivedLocality = value.first?.locality
                expectation.fulfill()
            })
        }
        self.wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(targetLocality, receivedLocality)
    }
    
    func testReverseGeocoderLocationFailure() {
        let expectation = XCTestExpectation()
        let targetLocation = CLLocation(latitude: 0, longitude: -0000012321123123)
        var hasError: Bool = false
        expectation.expectedFulfillmentCount = 1
        _ = CLGeocoder().rx.reverseGeocoderLocation(targetLocation).subscribe(onError: { (value) in
            hasError = true
            expectation.fulfill()
        })
        
        self.wait(for: [expectation], timeout: 1.0)
        
        XCTAssertTrue(hasError)

    }
}
