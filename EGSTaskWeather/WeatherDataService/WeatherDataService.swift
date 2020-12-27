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
    
    var weatherData: BehaviorSubject<DataResult> = BehaviorSubject<DataResult>(value: .empty)
    
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
        
        if  reachability.connection == .none {
            restoreFromStorage()
        }
        reachability.connectionSubject.subscribe(onNext: {[weak self] (connection) in
            if connection != .none, let location = placemark?.location, let locality = placemark?.locality   {
                self?.fetchFromNetwork(location: location, locality: locality)
            }
        }).disposed(by: disposeBag)
    }
    
    private func fetchFromNetwork(location: CLLocation, locality: String) {
        let getAllWeatherAPI = GetWeatherApi.getWeatherAll(location: location.coordinate, unit: .celsius)
        let urlBuilder = URLBuilder(for: getAllWeatherAPI)
        
        self.networkSession.request(with: urlBuilder).subscribe (onSuccess: { (result) in
            if let weatherModel = try?  WeatherModel.decode(from: result.0){
                self.weatherData.onNext(.some(locality: locality, weatherModel: weatherModel))
                self.sorageService.storeNewData(data: result.0, locality: locality, nil)
            }
            
        }).disposed(by: self.disposeBag)
    }
    
    private func restoreFromStorage() {
        self.sorageService.requestLastData().subscribe { (weatherEntity) in
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
