//
//  StorageServiceMock.swift
//  EGSTaskWeatherTests
//
//  Created by Dose on 12/27/20.
//

import RxSwift
@testable import EGSTaskWeather
import CoreData

/// Mock object of StorageService, works with CoreDataStackMock to store data in memory.
final class StorageServiceMock: StorageServiceProtocol {
    
    private var coreDataStackMock = CoreDataStackMock()
    
    func requestLastData() -> Single<WeatherEntity> {
        return Single.create {[weak self] (element) -> Disposable in
            guard let self = self else { return Disposables.create() }
            if let weatherEntity = WeatherEntity.findOrFetch(in: self.coreDataStackMock.storeContainer.viewContext) {
                element(.success(weatherEntity))

            } else {
                element(.error(RxError.noElements))
            }

            return Disposables.create()
        }
    }
    
    func storeNewData(data: Data, locality: String, _ completion: ((WeatherEntity) -> ())?) {
        let weatherEntity = WeatherEntity.findOrCreate(in: coreDataStackMock.storeContainer.viewContext)
        weatherEntity.weatherData = data
        weatherEntity.locality = locality
        completion?(weatherEntity)
    }
    
    
}
