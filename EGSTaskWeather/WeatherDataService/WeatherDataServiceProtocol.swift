//
//  WeatherDataServiceProtocol.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/27/20.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

/// Result type of Weather Data Fetch
enum DataResult {
    case empty
    case some(locality: String, weatherModel: WeatherModel)
}


//MARK: - WeatherDataServiceProtocol

protocol WeatherDataServiceProtocol {
    
    /// BehaviorSubject of DataResult
    var weatherData: BehaviorSubject<DataResult> { get }
    
    /// Requests weather data.
    /// - Parameter placemark: Weather data for placemark.
    ///
    /// If connection in unreachable fetchs from storage.
    func requestWeatherData(for placemark: CLPlacemark?)
}
