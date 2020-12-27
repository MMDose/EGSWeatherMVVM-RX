//
//  ReachabilityServiceMock.swift
//  EGSTaskWeatherTests
//
//  Created by Dose on 12/27/20.
//

import XCTest
import Reachability
import RxSwift
@testable import EGSTaskWeather

class ReachabilityServiceStub: ReachabilityServiceProtocol {
    
    var connectionSubject: BehaviorSubject<Reachability.Connection> = .init(value: .none)
    var connection: Reachability.Connection {
       return mutableConnection
    }
    var mutableConnection: Reachability.Connection = .none {
        didSet {
            connectionSubject.onNext(mutableConnection)
        }
    }
    
    init() {
        
    }
}
