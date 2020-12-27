//
//  StorageRequestProtocol.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/27/20.
//

import UIKit
import RxSwift
import CoreLocation

protocol StorageServiceProtocol {
    
    /// Returns Single observer which observes last saved data.
    func requestLastData() -> Single<WeatherEntity>
    
    /// Stores new data into storage.
    func storeNewData(data: Data, locality: String, _ completion: ((WeatherEntity)->())?)
}
