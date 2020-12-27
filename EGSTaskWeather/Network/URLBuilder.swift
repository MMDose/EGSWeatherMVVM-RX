//
//  URLBuilder.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/25/20.
//

import UIKit


// MARK: - URLBuilderProtocol

protocol URLBuilderProtocol {

    var urlComponents: URLComponents? { get }
    
    /// Returns created url if exist.
    func getURL() -> URL?
    
    /// Builds image url for given ID and APIKeys
    static func imageURL(for id: String, apiKeys: ApiKeyProtocol) -> URL
}


// MARK: - URLBuilderProtocol

final class URLBuilder: URLBuilderProtocol {
    
    private(set) var urlComponents: URLComponents?
    private(set) var apiKeys: ApiKeyProtocol
    
    init(for api: APIPressentable, apiKeyProtocol: ApiKeyProtocol = ApiKey()) {
        self.apiKeys = apiKeyProtocol
        buildURL(for: api, apiKeys: apiKeyProtocol)
    }
    
    /// Buillds URL with given API and APIKeys.
    private func buildURL(for api: APIPressentable, apiKeys: ApiKeyProtocol) {
        guard let url = URL(string: apiKeys.baseURL)?
                .appendingPathComponent(apiKeys.apiPath)
                .appendingPathComponent(apiKeys.apiVersion)
                .appendingPathComponent(api.path) else {
            return
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        switch api.method {
        case .get(queries: let queries):
            urlComponents?.queryItems = queries.map({ (key, value) -> URLQueryItem in
                return URLQueryItem(name: key, value: value)
            })
        }
        
        urlComponents?.queryItems?.append(URLQueryItem(name: "appid", value: apiKeys.appId))
        self.urlComponents = urlComponents
    }
    
    func getURL() -> URL? {
        return urlComponents?.url
    }
    
    static func imageURL(for id: String, apiKeys: ApiKeyProtocol = ApiKey()) -> URL {
        return URL(string: apiKeys.iconBase)!.appendingPathComponent(apiKeys.iconPath).appendingPathComponent("\(id)@2x").appendingPathExtension("png")
    }
}


