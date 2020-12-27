//
//  HomeViewModel.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/25/20.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import CoreLocation


//MARK: - HomeViewModelProtocol

protocol HomeViewModelProtocol {
    /// Observs current weather.
    var weatherRelay: PublishRelay<DataResult> { get }
    
    /// Bindable subject which observs `SmallAlert`,  bindable with controller, see Reactive extension for more details..
    var alertMessagesSubject: PublishSubject<SmallAlert> { get }
    
    /// Starts fetching weather.
    func fetchWeather()
}


//MARK: - HomeViewModel

final class HomeViewModel: HomeViewModelProtocol {
    
    private(set) var locationService: GeolocationProtocol
    private(set) var weatherDataService: WeatherDataServiceProtocol
    private let disposeBag = DisposeBag()
    
    //MARK: - Protocol Variables

    var weatherRelay: PublishRelay<DataResult> = PublishRelay<DataResult>()
    var alertMessagesSubject: PublishSubject<SmallAlert> = PublishSubject<SmallAlert>()
    
    init(locationService: GeolocationProtocol = GeolocationService(), weatherDataService: WeatherDataServiceProtocol = WeatherDataService()) {
        self.locationService = locationService
        self.weatherDataService = weatherDataService
        self.handleWeatherUpdates()
    }
    
    func fetchWeather() {
        handleLocationAuthorizationStatus()
        handlePlacemarksUpdates()
    }
    
    /// Starts receiving location placemark changes.
    ///
    /// Calls `locationManager.stopUpdatingLocation()` when receives first no-nill placemark.
    private func handlePlacemarksUpdates() {
        // Starts observing location updates and converts to placemark.
        locationService.placemarks.distinctUntilChanged().drive {[weak self] (placemark) in
            guard let self = self else { return }
            if placemark != nil {
                // When receives first non-nill placemark, stops updatingLocation.
                self.locationService.locationManager.stopUpdatingLocation()
            }
            // Requests to weather data.
            self.weatherDataService.requestWeatherData(for: placemark)
        }.disposed(by: disposeBag)
        
    }
    
    /// Starts receiving location authorization changes.
    ///
    /// When receives `false`(denied) shows error alert.
    private func handleLocationAuthorizationStatus() {
        let locationServiceUnavailableError = SmallAlert.locationServicesUnavailableError { (_) in
            // Redirect to Settings
            UIApplication.shared.redirectSettings()
        }
        // Starts observing authorization status.
        locationService.authorized.drive {[weak self] (value) in
            if value {
                // Removes pressented error view.
                locationServiceUnavailableError.retrieve?()
            } else {
                // Shows error message.
                self?.alertMessagesSubject.onNext(locationServiceUnavailableError)
            }
        }.disposed(by: disposeBag)
        
    }
    
    /// Starts receiving Weather updates.
    ///
    /// When receives `empty`  shows error alert.
    private func handleWeatherUpdates() {
        // Binds weather data with WeatherRelay.
        weatherDataService.weatherData.bind(to: weatherRelay).disposed(by: disposeBag)
        
    }
}
