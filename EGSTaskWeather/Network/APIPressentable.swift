//
//  APIPressentable.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/25/20.
//

import Foundation

enum RequestMethod {
    case get(queries: [String: String])
}

protocol APIPressentable {
    var method: RequestMethod { get }
    var path: String { get }
}

