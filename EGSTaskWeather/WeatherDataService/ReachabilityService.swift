//
//  ReachabilityService.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/27/20.
//

import UIKit
import RxReachability
import Reachability
import RxSwift


//MARK: - ReachabilityServiceProtocol

protocol ReachabilityServiceProtocol {
    /// Reachability connection status.
    var connection: Reachability.Connection { get }
    ///Reachablity connection status `BehaviorSubject`.
    var connectionSubject: BehaviorSubject<Reachability.Connection> { get }
}


//MARK: - ReachabilityService

final class ReachabilityService: ReachabilityServiceProtocol {
    
    var connection: Reachability.Connection
    var connectionSubject: BehaviorSubject<Reachability.Connection> = BehaviorSubject<Reachability.Connection>(value: .none)
    
    private var reachability = Reachability()
    private var disposeBag = DisposeBag()
    
    init() {
        // Start notifier
        try? reachability?.startNotifier()
        
        connection = reachability?.connection ?? .none
        // Bind to connectionSubject
        reachability?.rx.status.subscribe(onNext: {[weak self] element in
            self?.connectionSubject.onNext(element)
        }).disposed(by: disposeBag)
    }
    
    deinit {
        reachability?.stopNotifier()
    }
    
}

