//
//  WeatherModelTest.swift
//  EGSTaskWeatherTests
//
//  Created by Dose on 12/27/20.
//

import RxSwift
import RxTest
import RxCocoa
import CoreLocation
import XCTest
@testable import EGSTaskWeather

class WeatherModelTest: XCTestCase {
    
    func testWeaherModelDecoderConstructor() {
        
        let sessionMock: NetworkManagerProtocol = NetworkSessionMock()
        var weatherModel: WeatherModel? = nil
        let receivedError: Error? = nil
        let jsonDecoder = JSONDecoder()
        let expectation = XCTestExpectation()
        
        expectation.expectedFulfillmentCount = 1
        _ = sessionMock.request(with: URLBuilder(for: GetWeatherApi.getWeatherForCity(name: "", unit: .celsius), apiKeyProtocol: ValidAPIKeys())).subscribe (onSuccess: { (result) in
            weatherModel = try? jsonDecoder.decode(WeatherModel.self, from: result.0)
            expectation.fulfill()
        })
        
        self.wait(for: [expectation], timeout: 1.0)
        
        XCTAssertNil(receivedError, "\(receivedError!.localizedDescription)")
        XCTAssertNotNil(weatherModel)
        XCTAssertEqual(weatherModel?.current.weatherDescription[0].localizedDescription, "Clear - clear sky")
    }
    
}
