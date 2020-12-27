//
//  NetworkSessionMock.swift
//  EGSTaskWeatherTests
//
//  Created by Dose on 12/26/20.
//

import RxSwift
import RxTest
import RxCocoa
import CoreLocation

@testable import EGSTaskWeather

/// Mock object of Network session.
///
/// Session just parse `StubWeatherModelJSON` from test bundle. 
final class NetworkSessionMock: NetworkManagerProtocol {
    
    func request(with url: URLBuilderProtocol) -> Single<(Data, HTTPURLResponse)> {
        return Single.create { (observer) -> Disposable in
            
            if let filePath = Bundle.init(for: NetworkSessionMock.self).url(forResource: "StubWeatherModelJSON", withExtension: "json") {
                if let data = try? Data(contentsOf: filePath) {
                    observer(.success((data, HTTPURLResponse())))
                }
            }
            
            return Disposables.create()
        }
    }
}

