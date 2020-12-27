//
//  TestAPIKeys.swift
//  EGSTaskWeatherTests
//
//  Created by Dose on 12/26/20.
//


import UIKit

@testable import EGSTaskWeather

/// Valid API keys.
struct ValidAPIKeys: ApiKeyProtocol {
    var appId = "testAppID"
    var baseURL = "https://api.testHost.org/"
    var apiPath = "data"
    var apiVersion = "2.5"
    var iconBase = "http://imageLoader.org"
    var iconPath = "img/wn"
}

/// Invalid API keys.
struct InvalidAPIKeys: ApiKeyProtocol {
    var appId = "<>><Invalid><"
    var baseURL = "<>><Invalid><"
    var apiPath = "<>><Invalid><"
    var apiVersion = "<>><Invalid><"
    var iconBase = "<>><Invalid><"
    var iconPath = "<>><Invalid><"
}
