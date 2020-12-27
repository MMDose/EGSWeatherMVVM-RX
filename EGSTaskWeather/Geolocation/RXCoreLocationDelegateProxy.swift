//
//  RXCoreLocationDelegateProxy.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/25/20.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation


// MARK: - RXCoreLocationDelegateProxy

final class RXCoreLocationDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
    
    lazy var didUpdateLocationSubject = PublishSubject<[CLLocation]>()
    lazy var didUpdateAuthorizationSubject = PublishSubject<CLAuthorizationStatus>()
    lazy var didFailWithErrorSubject = PublishSubject<Error>()
    
    init(locationManager: CLLocationManager) {
        super.init(parentObject: locationManager, delegateProxy: RXCoreLocationDelegateProxy.self)
    }
    
    deinit {
        didUpdateAuthorizationSubject.onCompleted()
        didUpdateLocationSubject.onCompleted()
        didFailWithErrorSubject.onCompleted()
    }
}


// MARK: - DelegateProxyType

extension RXCoreLocationDelegateProxy: DelegateProxyType {
    static func registerKnownImplementations() {
        self.register { RXCoreLocationDelegateProxy(locationManager: $0)}
    }
}


// MARK: - CLLocationManagerDelegate

extension RXCoreLocationDelegateProxy: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        _forwardToDelegate?.locationManager(manager, didChangeAuthorization: status)
        didUpdateAuthorizationSubject.onNext(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _forwardToDelegate?.locationManager(manager, didUpdateLocations: locations)
        didUpdateLocationSubject.onNext(locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _forwardToDelegate?.locationManager(manager, didFailWithError: error)
        didFailWithErrorSubject.onNext(error)
    }
}


// MARK: - HasDelegate

extension CLLocationManager: HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}

