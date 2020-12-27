//
//  WeatherAPITests.swift
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

class WeatherAPITests: XCTestCase {
    
    let targetCityName = "Yerevan"
    let targetLocation = CLLocation(latitude: 40, longitude: 44)
    let targetForecastDays: Int = 2
    
    func testWeatherAPIPath() {
        let targetForecastPath = "forecast/daily"
        let targetWeatherPath = "weather"
        let targetOneCallPath = "onecall"

        let forecastApi = GetWeatherApi.getWeatherDailyForCity(name: targetCityName, unit: .celsius, forDays: targetForecastDays)
        let weatherApi = GetWeatherApi.getWeatherForCity(name: targetCityName, unit: .celsius)
        let oneCallApi = GetWeatherApi.getWeatherAll(location: targetLocation.coordinate, unit: .celsius)
        
        XCTAssertEqual(forecastApi.path, targetForecastPath)
        XCTAssertEqual(weatherApi.path, targetWeatherPath)
        XCTAssertEqual(oneCallApi.path, targetOneCallPath)
    }
    
    func testWeatherAPIQueries() {
        let forecastApi = GetWeatherApi.getWeatherDailyForCity(name: targetCityName, unit: .celsius, forDays: targetForecastDays)
        let weatherApi = GetWeatherApi.getWeatherForCity(name: targetCityName, unit: .celsius)
        let oneCallApi = GetWeatherApi.getWeatherAll(location: targetLocation.coordinate, unit: .celsius)
        
        var doesForecastDictionaryQueriesEqualToTarget: Bool = false
        var doesWeatherDictionaryQueriesEqualToTarget: Bool = false
        var doesGetAllDictionaryQueriesEqualToTarget: Bool = false

        
        let targetForecastDictionary: [String: String] = [
            "q":"\(targetCityName)",
            "units": WeatherUnits.celsius.rawValue,
            "cnt": "\(targetForecastDays)"
        ]
        
        let targetWeatherDictionary:  [String: String] = [
            "q":"\(targetCityName)",
            "units": WeatherUnits.celsius.rawValue
        ]
        
        let targetOneCallDictionary: [String: String] = [
            "lat":"\(targetLocation.coordinate.latitude)",
            "lon":"\(targetLocation.coordinate.longitude)",
            "units": WeatherUnits.celsius.rawValue
        ]
        
        if case .get(let queries) = forecastApi.method {
            doesForecastDictionaryQueriesEqualToTarget = queries == targetForecastDictionary
        }
        
        if case .get(let queries) = weatherApi.method {
            doesWeatherDictionaryQueriesEqualToTarget = queries == targetWeatherDictionary
        }
        
        if case .get(let queries) = oneCallApi.method {
            doesGetAllDictionaryQueriesEqualToTarget = queries == targetOneCallDictionary
        }
        
        XCTAssertTrue(doesForecastDictionaryQueriesEqualToTarget)
        XCTAssertTrue(doesWeatherDictionaryQueriesEqualToTarget)
        XCTAssertTrue(doesGetAllDictionaryQueriesEqualToTarget)

    }
}


