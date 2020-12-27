//
//  APIs.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/25/20.
//

import UIKit

/// APIKeys protocol. 
public protocol ApiKeyProtocol {
    var appId: String { get }
    var baseURL: String { get }
    var apiPath: String { get }
    var apiVersion: String { get }
    var iconBase: String { get }
    var iconPath: String { get }
}

/// Application production APIKeys.
struct ApiKey: ApiKeyProtocol {
    var appId = "5628f44b7d09b8dde9ee8915ce0afc18"
    var baseURL = "https://api.openweathermap.org/"
    var apiPath = "data"
    var apiVersion = "2.5"
    var iconBase = "http://openweathermap.org"
    var iconPath = "img/wn"
    
}

