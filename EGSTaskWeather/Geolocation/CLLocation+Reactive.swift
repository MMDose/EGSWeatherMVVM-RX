//
//  CLLocation+Reactive.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/26/20.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation


// MARK: - DelegateProxyType Reactive

extension Reactive where Base: CLLocationManager {
    
    ///Observable of didUpdateLocation.
    public var didUpdateLocations: Observable<[CLLocation]> {
        return RXCoreLocationDelegateProxy.proxy(for: base).didUpdateLocationSubject.asObservable()
    }
    ///Observable of didUpdateAuthorization.
    public var didUpdateAuthorizationStatus: Observable<CLAuthorizationStatus> {
        return RXCoreLocationDelegateProxy.proxy(for: base).didUpdateAuthorizationSubject.asObservable()
    }
    /// Observable of didFailWithError
    public var didFailWithError: Observable<Error> {
        return RXCoreLocationDelegateProxy.proxy(for: base).didFailWithErrorSubject.asObservable()
    }
    
}
