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


//MARK: - WeatherDataServiceProtocol

protocol WeatherDataServiceProtocol {
    
    /// BehaviorSubject of DataResult.
    ///
    /// After fetch process subject start observing weather data.
    var weatherData: PublishSubject<DataResult> { get }
    
    /// Requests weather data.
    /// - Parameter placemark: Weather data for placemark.
    ///
    /// If connection is unreachable' fetchs from storage.
    func requestWeatherData(for placemark: CLPlacemark?)
}
