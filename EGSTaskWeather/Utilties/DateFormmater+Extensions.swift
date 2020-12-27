//
//  DateFormmater+Extensions.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/26/20.
//

import UIKit

extension DateFormatter {
    
    /// Returns week day from date.
    static func getWeekDay(from date: Date) -> String {
        let formmater = DateFormatter()
        let weekDay = formmater.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
        return weekDay
    }
}
