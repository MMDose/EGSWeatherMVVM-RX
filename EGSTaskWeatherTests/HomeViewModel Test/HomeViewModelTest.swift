//
//  HomeViewModelTest.swift
//  EGSTaskWeatherTests
//
//  Created by Dose on 12/27/20.
//

import RxSwift
import RxCocoa
import XCTest
import CoreLocation
@testable import EGSTaskWeather

class HomeViewModelTest: XCTestCase {
    
    var weatherDataServiceMock: WeatherDataServiceMock!
    var geolocationService: GeolocationProtocol!
    var homeViewModel: HomeViewModel!
    var locationManager: CLLocationManager!
    
    override func setUp() {
        super.setUp()
        locationManager = CLLocationManager()
        weatherDataServiceMock = WeatherDataServiceMock()
        geolocationService = GeolocationService(locationManager: locationManager)
        homeViewModel = HomeViewModel(locationService: geolocationService, weatherDataService: weatherDataServiceMock)
    }
    
    override func tearDown() {
        super.tearDown()
        weatherDataServiceMock = nil
        geolocationService = nil
        homeViewModel = nil
        locationManager = nil
    }
    
    func testCurrentCitySubject() {
        // For geolocation protocol its required that device should be connected to network oterwise test will failure.

        weatherDataServiceMock.isReachibly = true 
        let expectation = XCTestExpectation()
        let targetLocation = CLLocation(latitude: 40.18111, longitude: 44.51361)
        let targetLocality: String = "Yerevan"
        var receivedLocality: String?
        expectation.expectedFulfillmentCount = 1
        _ = homeViewModel.weatherRelay.subscribe(onNext: { value in
            if case .some(let locality,_) = value {
                receivedLocality = locality
            }
            expectation.fulfill()
            
        })
        homeViewModel.fetchWeather()

        geolocationService.locationManager.delegate!.locationManager!(locationManager, didUpdateLocations: [targetLocation])
                
        self.wait(for: [expectation], timeout: 1)
        XCTAssertEqual(targetLocality, receivedLocality)
    }
    
    func testCurrentWeatherSubject() {
        weatherDataServiceMock.isReachibly = true 
        let expectation = XCTestExpectation()
        let targetLocation = CLLocation(latitude: 40.177200, longitude: 44.503490)
        var receivedWeather: WeatherModel.CurrentWeather?
        
        expectation.expectedFulfillmentCount = 1
        _ = homeViewModel.weatherRelay.subscribe(onNext: { value in
                if case .some(_,let weather) = value {
                    receivedWeather = weather.current
                }
                expectation.fulfill()
            })
        homeViewModel.fetchWeather()
        geolocationService.locationManager.delegate!.locationManager!(locationManager, didUpdateLocations: [targetLocation])

        self.wait(for: [expectation], timeout: 1)
        XCTAssertEqual(receivedWeather?.cloudsPercentage, 0.0)
        XCTAssertEqual(receivedWeather?.weatherDescription[0].description, "clear sky")
        XCTAssertEqual(receivedWeather?.weatherDescription[0].main, "Clear")
        XCTAssertEqual(receivedWeather?.temperature, 286.01)
        XCTAssertEqual(receivedWeather?.humidity, 72.0)

    }
    
    func testDailyWeatherSubject() {
        weatherDataServiceMock.isReachibly = true
        let expectation = XCTestExpectation()
        let targetLocation = CLLocation(latitude: 40.177200, longitude: 44.503490)
        var receivedWeather: [WeatherModel.Daily]?
        
        expectation.expectedFulfillmentCount = 1

        _ = homeViewModel.weatherRelay.subscribe(onNext: { value in
            if case .some(_,let weather) = value {
                receivedWeather = weather.daily
            }
                expectation.fulfill()
            })
        homeViewModel.fetchWeather()
        geolocationService.locationManager.delegate!.locationManager!(locationManager, didUpdateLocations: [targetLocation])

        self.wait(for: [expectation], timeout: 1)
        
        XCTAssertNotNil(receivedWeather)
        XCTAssertEqual(receivedWeather![0].temperatureMax, 286.37)
        XCTAssertEqual(receivedWeather![0].temperatureMin, 284.65)
        XCTAssertEqual(receivedWeather![0].weekDay, "Saturday")

    }
}
