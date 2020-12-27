//
//  WeatherDataService.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/27/20.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation


//MARK: - WeatherDataService

final class WeatherDataService: WeatherDataServiceProtocol {
    
    var weatherData: PublishSubject<DataResult> = PublishSubject<DataResult>()
    
    private var disposeBag = DisposeBag()
    private var reachability: ReachabilityServiceProtocol
    private var networkSession: NetworkManagerProtocol
    private var sorageService: StorageServiceProtocol
    
    init(networkSevice: NetworkManagerProtocol = NetworkManager(),
         storageSession: StorageServiceProtocol = StorageService(),
         reachability: ReachabilityServiceProtocol = ReachabilityService()) {
        self.reachability = reachability
        self.networkSession = networkSevice
        self.sorageService = storageSession
    }
    
    func requestWeatherData(for placemark: CLPlacemark?) {
        // If connection is unreachable restore from storage.
        if  reachability.connection == .none {
            restoreFromStorage()
        }
        // Observe connection reachability
        reachability.connectionSubject.subscribe(onNext: {[weak self] (connection) in
            if connection != .none {
                if let location = placemark?.location, let locality = placemark?.locality {
                    // if connection is available request data.
                    self?.fetchFromNetwork(location: location, locality: locality)
                } else {
                    self?.weatherData.onNext(.empty)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    /// Fetchs Weather from Network.
    /// - Parameters:
    ///   - location: Location of placemark.
    ///   - locality: Locality of placemark.
    private func fetchFromNetwork(location: CLLocation, locality: String) {
        let getAllWeatherAPI = GetWeatherApi.getWeatherAll(location: location.coordinate, unit: .celsius)
        let urlBuilder = URLBuilder(for: getAllWeatherAPI)
        
        self.networkSession.request(with: urlBuilder).subscribe (onSuccess: { (result) in
            if let weatherModel = try?  WeatherModel.decode(from: result.0){
                // Pass weather to BehaviorSubject, and store in local storage.
                self.weatherData.onNext(.some(locality: locality, weatherModel: weatherModel))
                self.sorageService.storeNewData(data: result.0, locality: locality, nil)
            }
            //FIXME: - Needs handle case when result is nil, or data for current location is unavalable.
        }).disposed(by: self.disposeBag)
    }
    
    /// Restores weather data from local storage.
    private func restoreFromStorage() {
        self.sorageService.requestLastData().subscribe { (weatherEntity) in
            // Pass weather to BehaviotSubject.

            if let weatherModel = try? WeatherModel.decode(from: weatherEntity.weatherData) {
                self.weatherData.onNext(.some(locality: weatherEntity.locality, weatherModel: weatherModel))
            } else {
                
                self.weatherData.onNext(.empty)
            }
        } onError: { (error) in
            self.weatherData.onNext(.empty)
        }.disposed(by: self.disposeBag)
        
    }
}
