//
//  UtilitiesTests.swift
//  EGSTaskWeatherTests
//
//  Created by Dose on 12/26/20.
//

import UIKit
import XCTest
import RxSwift
import RxCocoa

@testable import EGSTaskWeather

class UtilitiesTests: XCTestCase {
    
    func testDateToHour() {
        let targetTimeInterval: TimeInterval = 1609005627
        let targetString = "10:00 PM"
        let date = Date(timeIntervalSince1970: targetTimeInterval)
        XCTAssertEqual(date.toHours(), targetString)
    }
    
    func testDateFormmaterExtensions() {
        let targetTimeInterval: TimeInterval = 1609005627
        let targetString = "Saturday"
        let date = Date(timeIntervalSince1970: targetTimeInterval)
        XCTAssertEqual(DateFormatter.getWeekDay(from: date), targetString)

    }
    
    func testStoryboardInitializable() {
        let targetViewControllerName: String = "HomeViewController"
        
        XCTAssertNotNil(HomeViewController.initFromStoryboard(name: "Home"))
        XCTAssertEqual(targetViewControllerName, HomeViewController.viewControllerStoryboardID)
    }
    
    func testReuseIdentifible() {
        let targetCellName = "WeatherCell"
        XCTAssertEqual(WeatherCell.reuseIdentifier(), targetCellName)
    }
    
    
}

