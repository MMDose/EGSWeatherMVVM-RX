//
//  NetworkErrors.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/27/20.
//

import Foundation

enum NetworkErrors: Error {
    
    case invalidURL

    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        }
    }
}
