//
//  NetworkingManager.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/25/20.
//

import UIKit
import RxSwift
import RxCocoa


//MARK: - NetworkManagerProtocol

protocol NetworkManagerProtocol {
    /// Requests response for given URL.
    /// - Returns: Single observer which observs Data and Response.
    func request(with url: URLBuilderProtocol) -> Single<(Data, HTTPURLResponse)>
}


//MARK: - NetworkManager

final class NetworkManager: NetworkManagerProtocol {

    func request(with url: URLBuilderProtocol) -> Single<(Data, HTTPURLResponse)> {
        return Observable.just(url.getURL()).flatMap { (url) -> Observable<(response: HTTPURLResponse, data: Data)> in
            guard let url = url else { throw NetworkErrors.invalidURL }
            return URLSession.shared.rx.response(request: URLRequest(url: url))
        }.map { (response, data) in
            if 200 ..< 300 ~= response.statusCode {
                return (data,response)
            } else {
                throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
            }
        }.asSingle()
    }
}
