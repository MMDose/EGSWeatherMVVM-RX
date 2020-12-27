//
//  Geocoder.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/26/20.
//

import CoreLocation
import RxSwift
import RxCocoa


private let semaphore = DispatchSemaphore(value: 1)


// MARK: - CLGeocoder Reactive

extension Reactive where Base: CLGeocoder {
    
    /// Responsable for getting location placemark from CLGeocoder. 
    /// - Parameter location: Specify location to get info.
    /// - Returns: Observable of CLPlacemark.
    ///
    /// Function is `Thread Safe`.
    func reverseGeocoderLocation(_ location: CLLocation) -> Observable<[CLPlacemark]> {
        return Observable<[CLPlacemark]>.create { (observer) -> Disposable in
            semaphore.wait()
            geocoderHandler(observer) { (result) in
                self.base.reverseGeocodeLocation(location, completionHandler: result)
            }
            return Disposables.create {
                self.base.cancelGeocode()
                semaphore.signal()
            }
        }
    }
    
    private func geocoderHandler(_ observer: AnyObserver<[CLPlacemark]>, result: @escaping (@escaping CLGeocodeCompletionHandler) -> Void) {
        result { placemark, error in
            guard let placemark = placemark else {
                observer.onError(RxError.noElements)
                return
            }
            observer.onNext(placemark)
            observer.onCompleted()
        }
    }
}
