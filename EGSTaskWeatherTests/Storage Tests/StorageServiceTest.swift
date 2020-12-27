//
//  StorageServiceTest.swift
//  EGSTaskWeatherTests
//
//  Created by Dose on 12/27/20.
//

import UIKit
import RxSwift
import RxCocoa
import XCTest
@testable import EGSTaskWeather

class StorageServiceTest: XCTestCase {

    var storageService: StorageServiceProtocol!
    var coreDataStack: CoreDataStackProtocol!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStackMock()
        storageService = StorageService(coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        super.tearDown()
        storageService = nil
        coreDataStack = nil
        
    }
    
    func testAddWeatherToStorage() {
        let locality = "Yerevan"
        var weatherData: Data!
        var savedEntity: WeatherEntity!
        
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        
        _ = NetworkSessionMock().request(with: URLBuilder(for: GetWeatherApi.getWeatherForCity(name: "", unit: .celsius))).subscribe (onSuccess: { (data) in
            weatherData = data.0
            expectation.fulfill()
        })

        self.wait(for: [expectation], timeout: 1.0)
        
        storageService.storeNewData(data: weatherData, locality: locality) { entity in
            savedEntity = entity
            self.expectation(forNotification: .NSManagedObjectContextDidSave, object: self.coreDataStack.storeContainer.viewContext) { (_) -> Bool in
                return true
            }
        }
        
        self.waitForExpectations(timeout: 2.0) { (error) in
            XCTAssertEqual(savedEntity.locality, locality)
            XCTAssert(!savedEntity.weatherData.isEmpty)
            XCTAssertEqual(savedEntity.weatherData, weatherData)
            XCTAssertNil(error)
        }
    }
    
    func testGetWeatherFromStorage() {
        let locality = "Yerevan"
        var weatherData: Data!
        var savedEntity: WeatherEntity!
        var receivedEntity: WeatherEntity!
        
        // Returns WeatherModel from bundle.
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
        
        _ = NetworkSessionMock().request(with: URLBuilder(for: GetWeatherApi.getWeatherForCity(name: "", unit: .celsius))).subscribe (onSuccess: { (data) in
            weatherData = data.0
            expectation.fulfill()
        })

        self.wait(for: [expectation], timeout: 1.0)
        
        storageService.storeNewData(data: weatherData, locality: locality) { entity in
            savedEntity = entity
            self.expectation(forNotification: .NSManagedObjectContextDidSave, object: self.coreDataStack.storeContainer.viewContext) { (_) -> Bool in
                return true
            }
        }
        
        self.waitForExpectations(timeout: 2.0, handler: { error in
            let requestExpectation = XCTestExpectation()
            requestExpectation.expectedFulfillmentCount = 1
            _ = self.storageService.requestLastData().subscribe(onSuccess: { weather in
                receivedEntity = weather
                requestExpectation.fulfill()
            })
            self.wait(for: [requestExpectation], timeout: 2)
            XCTAssertEqual(savedEntity.locality, receivedEntity.locality)
            XCTAssertEqual(savedEntity.weatherData, receivedEntity.weatherData)
        })
    }
}
