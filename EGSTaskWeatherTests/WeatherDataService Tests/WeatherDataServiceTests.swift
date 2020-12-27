//
//  WeatherDataServiceTests.swift
//  EGSTaskWeatherTests
//
//  Created by Dose on 12/27/20.
//

import RxSwift
import RxCocoa
import XCTest
import CoreLocation
@testable import EGSTaskWeather


class WeatherDataServiceTests: XCTestCase {
    
    var rechabilityServiceStub: ReachabilityServiceStub!
    var storageServiceMock: StorageServiceProtocol!
    var networkServiceMock: NetworkSessionMock!
    var weatherDataService: WeatherDataService!
    
    override func tearDown() {
        super.tearDown()
        self.rechabilityServiceStub = nil
        self.storageServiceMock = nil
        self.networkServiceMock = nil
        self.weatherDataService = nil
    }
    
    override func setUp() {
        super.setUp()
        self.rechabilityServiceStub = ReachabilityServiceStub()
        self.storageServiceMock = StorageServiceMock()
        self.networkServiceMock = NetworkSessionMock()
        self.weatherDataService = WeatherDataService(networkSevice: networkServiceMock, storageSession: storageServiceMock, reachability: rechabilityServiceStub)
    }
    

    func testRequestWeatherPlacemarkNotNillReachabilityConnected() {
        rechabilityServiceStub.mutableConnection = .cellular
        let geocoderExpectation = XCTestExpectation()
        let targetLocation = CLLocation(latitude: 40.177200, longitude: 44.503490)
        let targetCity = "Yerevan"
        var receivedPlacemark: CLPlacemark?
        var receivedLocaly: String?
        var receivedWeatherData: WeatherModel?
        var unAvailableData: Bool = false
        var receivedError: Bool = false
        
        geocoderExpectation.expectedFulfillmentCount = 1

        let locationManager = CLLocationManager()
        
        let geolocation: GeolocationProtocol = GeolocationService(locationManager: locationManager)
        _ = geolocation.placemarks.drive (onNext: { (value) in
            receivedPlacemark = value
            geocoderExpectation.fulfill()
        })
        locationManager.delegate!.locationManager!(locationManager, didUpdateLocations: [targetLocation])
        
        
        self.wait(for: [geocoderExpectation], timeout: 1)
            
        let weatherDataExpectation = XCTestExpectation()
        weatherDataExpectation.expectedFulfillmentCount = 1
        weatherDataService.requestWeatherData(for: receivedPlacemark)

        _ = weatherDataService.weatherData.subscribe { (result) in
            switch result {
            case.some(locality: let localy, weatherModel: let weather):
                receivedLocaly = localy
                receivedWeatherData = weather
            case .empty:
                unAvailableData = true
            }
            weatherDataExpectation.fulfill()

        } onError: { (error) in
            weatherDataExpectation.fulfill()

            receivedError = true
        }
        self.wait(for: [weatherDataExpectation], timeout: 2.0)
        
        XCTAssertEqual(receivedLocaly, targetCity)
        XCTAssertNotNil(receivedWeatherData)
        XCTAssertFalse(unAvailableData)
        XCTAssertFalse(receivedError)

    }
    
    func testRequestWeatherPlacemarkNotNillReachabilityDisconnected() {
        rechabilityServiceStub.mutableConnection = .none
        let geocoderExpectation = XCTestExpectation()
        let targetLocation = CLLocation(latitude: 40.177200, longitude: 44.503490)
        let targetCity = "Yerevan"
        var receivedPlacemark: CLPlacemark?
        var receivedLocaly: String?
        var receivedWeatherData: WeatherModel?
        var unAvailableData: Bool = false
        var receivedError: Bool = false
        
        geocoderExpectation.expectedFulfillmentCount = 1
        
        let locationManager = CLLocationManager()
        
        let geolocation: GeolocationProtocol = GeolocationService(locationManager: locationManager)
        _ = geolocation.placemarks.drive (onNext: { (value) in
            receivedPlacemark = value
            geocoderExpectation.fulfill()
        })
        locationManager.delegate!.locationManager!(locationManager, didUpdateLocations: [targetLocation])
        
        
        self.wait(for: [geocoderExpectation], timeout: 1)
        
        let weatherDataExpectation = XCTestExpectation()
        weatherDataExpectation.expectedFulfillmentCount = 1
        weatherDataService.requestWeatherData(for: receivedPlacemark)

        _ = weatherDataService.weatherData.subscribe { (result) in
            switch result {
            case.some(locality: let localy, weatherModel: let weather):
                receivedLocaly = localy
                receivedWeatherData = weather
            case .empty:
                unAvailableData = true
            }
            weatherDataExpectation.fulfill()

            
        } onError: { (error) in
            weatherDataExpectation.fulfill()

            receivedError = true
        }
        self.wait(for: [weatherDataExpectation], timeout: 2.0)
        
        XCTAssertNotEqual(receivedLocaly, targetCity)
        XCTAssertNil(receivedWeatherData)
        XCTAssertTrue(unAvailableData)
        XCTAssertFalse(receivedError)

    }
    
    func testRequestWeatherPlacemarkNillReachabilityConnected() {
        rechabilityServiceStub.mutableConnection = .cellular
        let receivedPlacemark: CLPlacemark?  = nil
        var unAvailableData: Bool = false
        var receivedError: Bool = false
            
        let weatherDataExpectation = XCTestExpectation()
        weatherDataExpectation.expectedFulfillmentCount = 1
        weatherDataService.requestWeatherData(for: receivedPlacemark)

        _ = weatherDataService.weatherData.subscribe { (result) in
            switch result {
            case .empty:
                unAvailableData = true
            default: break
            }
            weatherDataExpectation.fulfill()
        } onError: { (error) in
            weatherDataExpectation.fulfill()
            receivedError = true
        }
        self.wait(for: [weatherDataExpectation], timeout: 2.0)

        XCTAssertTrue(unAvailableData)
        XCTAssertFalse(receivedError)

    }
    
}
