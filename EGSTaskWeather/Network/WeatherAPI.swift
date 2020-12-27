//
//  APIBuilder.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/25/20.
//

import UIKit
import CoreLocation


// MARK: - WeatherUnits

enum WeatherUnits: String {
    case celsius = "metric"
    case fahrenheit = "imperial"
}


// MARK: - GetWeatherApi

enum GetWeatherApi: APIPressentable {
    
    case getWeatherForCity(name: String, unit: WeatherUnits = .celsius)
    case getWeatherDailyForCity(name: String, unit: WeatherUnits = .celsius, forDays: Int)
    case getWeatherAll(location: CLLocationCoordinate2D, unit: WeatherUnits = .celsius)
    
    var path: String {
        switch self {
        case .getWeatherDailyForCity:
            return "forecast/daily"
        case .getWeatherForCity:
            return "weather"
        case .getWeatherAll:
            return "onecall"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .getWeatherForCity(name: let city, let unit):
            return .get(queries: [
                "q":"\(city)",
                "units": unit.rawValue
            ])
        case .getWeatherDailyForCity(name: let city, unit: let unit, forDays: let days):
            return .get(queries: [
                "q":"\(city)",
                "cnt":"\(days)",
                "units": unit.rawValue
            ])
        case .getWeatherAll(location: let location, unit: let unit):
        return .get(queries: [
            "lat":"\(location.latitude)",
            "lon": "\(location.longitude)",
            "units": unit.rawValue
        ])
        }
    }
}
