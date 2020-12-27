//
//  StorageService.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/27/20.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa


//MARK: - StorageService

final class StorageService {
    

    private var coreDataStack: CoreDataStackProtocol
    
    init(coreDataStack: CoreDataStackProtocol = CoreDataStack()) {
        self.coreDataStack = coreDataStack
    }
}


//MARK: - StorageRequestProtocol

extension StorageService: StorageServiceProtocol {
    
    func storeNewData(data: Data, locality: String, _ completion: ((WeatherEntity)->())? = nil) {
        coreDataStack.storeContainer.viewContext.performChanges {
           let entity = WeatherEntity.findOrCreate(into: self.coreDataStack.storeContainer.viewContext, weatherData: data, locality: locality)
            completion?(entity)
        }
    }

    
    func requestLastData() -> Single<WeatherEntity> {
        
        return Single<WeatherEntity>.create {[weak self] (observer) -> Disposable in
            guard let self = self else {
                observer(.error(RxError.unknown))
                return Disposables.create()
            }
            if let weatherEntity = WeatherEntity.findOrFetch(in: self.coreDataStack.storeContainer.viewContext) {
                observer(.success(weatherEntity))

            } else {
                observer(.error(RxError.noElements))
            }
            return Disposables.create()
        }
    }
}
