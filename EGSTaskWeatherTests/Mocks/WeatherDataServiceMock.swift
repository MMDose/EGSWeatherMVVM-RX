//
//  WeatherDataServiceMock.swift
//  EGSTaskWeatherTests
//
//  Created by Dose on 12/27/20.
//

import RxSwift
import RxCocoa
import CoreLocation
@testable import EGSTaskWeather

/// Mock object of `WeatherDataService`, parse `StubWeatherModelJSON` json from TestBundle. 
final class WeatherDataServiceMock: WeatherDataServiceProtocol {
    
    var weatherData: PublishSubject<DataResult> = PublishSubject<DataResult>()
    
    private let networkSessionMock = NetworkSessionMock()
    
    var isReachibly: Bool = false
    private var disposeBag = DisposeBag()
    
    deinit {
        print("Weather mock object deinited")
    }
    
    func requestWeatherData(for placemark: CLPlacemark?) {
         networkSessionMock.request(with: URLBuilder(for: GetWeatherApi.getWeatherForCity(name: "", unit: .celsius))).subscribe {[weak self] (result) in
            guard let self = self else { return }
            
            if let decodedWeather = try? JSONDecoder().decode(WeatherModel.self, from: result.0), self.isReachibly {
                self.weatherData.onNext(.some(locality: placemark?.locality ?? "", weatherModel: decodedWeather))
            } else {
                self.weatherData.onNext(.empty)
            }
        } onError: { (error) in
            self.weatherData.onNext(.empty)
        }.disposed(by: disposeBag)
        
    }
}


