//
//  URLBuilderTests.swift
//  EGSTaskWeatherTests
//
//  Created by Dose on 12/26/20.
//

import RxSwift
import RxTest
import RxCocoa
import CoreLocation
import XCTest
@testable import EGSTaskWeather

class URLBuilderTests: XCTestCase {
    let validAPIKeys = ValidAPIKeys()
    let invalidAPIKeys = InvalidAPIKeys()
    let targetCity = "Yerevan"
    let targetLocation = CLLocation(latitude: 40, longitude: 40)
    let targetForecastDays: Int = 3
    
    let targetForecastURL = URLComponents(url: URL(string: "https://api.testHost.org/data/2.5/forecast/daily?cnt=3&units=metric&q=Yerevan&appid=testAppID")!, resolvingAgainstBaseURL: false)
    let targetOneCallURL = URLComponents(url: URL(string: "https://api.testHost.org/data/2.5/onecall?lat=40.0&units=metric&lon=40.0&appid=testAppID")!, resolvingAgainstBaseURL: false)
    let targetWeatherURL = URLComponents(url: URL(string: "https://api.testHost.org/data/2.5/weather?units=metric&q=Yerevan&appid=testAppID")!, resolvingAgainstBaseURL: false)
    
    var doesForecastURLQueriesEqual: Bool? = true
    var doesWeatherURLQueriesEqual: Bool? = true
    var doesOneCallURLQueriesEqual: Bool? = true
    
    override func setUp() {
        doesForecastURLQueriesEqual = true
        doesWeatherURLQueriesEqual = true
        doesOneCallURLQueriesEqual = true
        
    }
    
    func testURLBuilderValidURL() {
      
        
        let targetForecastApi = GetWeatherApi.getWeatherDailyForCity(name: targetCity, unit: .celsius, forDays: targetForecastDays)
        let targetOneCallApi = GetWeatherApi.getWeatherAll(location: targetLocation.coordinate, unit: .celsius)
        let targetWeatherApi = GetWeatherApi.getWeatherForCity(name: targetCity, unit: .celsius)
        
        let urlForecastBuilder = URLBuilder(for: targetForecastApi, apiKeyProtocol: validAPIKeys )
        let urlOneCallBuilder = URLBuilder(for: targetOneCallApi, apiKeyProtocol: validAPIKeys)
        let urlWeatherBuilder = URLBuilder(for: targetWeatherApi, apiKeyProtocol: validAPIKeys)
        
        targetForecastURL?.queryItems?.forEach({ (query) in
            doesForecastURLQueriesEqual = urlForecastBuilder.urlComponents?.queryItems?.contains(query)
        })

        targetOneCallURL?.queryItems?.forEach({ (query) in
            doesOneCallURLQueriesEqual = urlOneCallBuilder.urlComponents?.queryItems?.contains(query)
        })

        targetWeatherURL?.queryItems?.forEach({ (query) in
            doesWeatherURLQueriesEqual = urlWeatherBuilder.urlComponents?.queryItems?.contains(query)

        })
        
        XCTAssertEqual(targetForecastURL?.url?.path, urlForecastBuilder.getURL()?.path)
        XCTAssertEqual(targetOneCallURL?.url?.path, urlOneCallBuilder.getURL()?.path)
        XCTAssertEqual(targetWeatherURL?.url?.path, urlWeatherBuilder.getURL()?.path)
        
        XCTAssertEqual(targetForecastURL?.path, urlForecastBuilder.urlComponents?.path)
        XCTAssertEqual(targetOneCallURL?.path, urlOneCallBuilder.urlComponents?.path)
        XCTAssertEqual(targetWeatherURL?.path, urlWeatherBuilder.urlComponents?.path)

        XCTAssertEqual(targetForecastURL?.host, urlForecastBuilder.urlComponents?.host)
        XCTAssertEqual(targetOneCallURL?.host, urlOneCallBuilder.urlComponents?.host)
        XCTAssertEqual(targetWeatherURL?.host, urlWeatherBuilder.urlComponents?.host)

        XCTAssertNotNil(doesWeatherURLQueriesEqual)
        XCTAssertNotNil(doesForecastURLQueriesEqual)
        XCTAssertNotNil(doesOneCallURLQueriesEqual)
        XCTAssert(doesWeatherURLQueriesEqual!)
        XCTAssert(doesForecastURLQueriesEqual!)
        XCTAssert(doesOneCallURLQueriesEqual!)

    }
    
    func testURLBuilderInValidURL() {
      
        let targetForecastApi = GetWeatherApi.getWeatherDailyForCity(name: targetCity, unit: .celsius, forDays: targetForecastDays)
        let targetOneCallApi = GetWeatherApi.getWeatherAll(location: targetLocation.coordinate, unit: .celsius)
        let targetWeatherApi = GetWeatherApi.getWeatherForCity(name: targetCity, unit: .celsius)
        
        let urlForecastBuilder = URLBuilder(for: targetForecastApi, apiKeyProtocol: invalidAPIKeys )
        let urlOneCallBuilder = URLBuilder(for: targetOneCallApi, apiKeyProtocol: invalidAPIKeys)
        let urlWeatherBuilder = URLBuilder(for: targetWeatherApi, apiKeyProtocol: invalidAPIKeys)
        
        
        XCTAssertNil(urlForecastBuilder.urlComponents)
        XCTAssertNil(urlOneCallBuilder.urlComponents)
        XCTAssertNil(urlWeatherBuilder.urlComponents)

    }
    
    func testURLBuilderValidURLGetImageURL() {
        let url = URLBuilder.imageURL(for: "0x0", apiKeys: validAPIKeys)
        let targetURL: String = "http://imageLoader.org/img/wn/0x0@2x.png"
        XCTAssertEqual(url.absoluteString, targetURL)
        
    }
    
    func testNetworkErrorInvalidURLBuilder() {
        let targetForecastApi = GetWeatherApi.getWeatherDailyForCity(name: targetCity, unit: .celsius, forDays: targetForecastDays)
        let targetOneCallApi = GetWeatherApi.getWeatherAll(location: targetLocation.coordinate, unit: .celsius)
        let targetWeatherApi = GetWeatherApi.getWeatherForCity(name: targetCity, unit: .celsius)
        
        let urlForecastBuilder = URLBuilder(for: targetForecastApi, apiKeyProtocol: invalidAPIKeys)
        let urlOneCallBuilder = URLBuilder(for: targetOneCallApi, apiKeyProtocol: invalidAPIKeys)
        let urlWeatherBuilder = URLBuilder(for: targetWeatherApi, apiKeyProtocol: invalidAPIKeys)
        
        let expectaion = XCTestExpectation()
        expectaion.expectedFulfillmentCount = 3
        
        var networkErrorForecastApi: NetworkErrors?
        var networkErrorWeatherApi: NetworkErrors?
        var networkErrorOneCallApi: NetworkErrors?

        
        _ = NetworkManager().request(with: urlForecastBuilder).subscribe(onError: { (error) in
            networkErrorForecastApi = error as? NetworkErrors
            expectaion.fulfill()
            
        })
        _ = NetworkManager().request(with: urlOneCallBuilder).subscribe(onError: { (error) in
            networkErrorOneCallApi = error as? NetworkErrors
            expectaion.fulfill()
        })
        _ = NetworkManager().request(with: urlWeatherBuilder).subscribe(onError: { (error) in
            networkErrorWeatherApi = error as? NetworkErrors
            expectaion.fulfill()
        })
        
        

        self.wait(for: [expectaion], timeout: 1.0)
        
        XCTAssertEqual(networkErrorOneCallApi?.errorDescription, "Invalid URL")
        XCTAssertEqual(networkErrorWeatherApi?.errorDescription, "Invalid URL")
        XCTAssertEqual(networkErrorForecastApi?.errorDescription, "Invalid URL")

        
    }
}
