//
//  Date+ToHour.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/26/20.
//

import Foundation

extension Date {
    
    /// Converts Date to human readibilty hours.
    /// - Returns: Hours with format `h:mm a - 06:34 AM` 
    func toHours() -> String {
        let formmater = DateFormatter()
        formmater.dateFormat = "h:mm a"
        return formmater.string(from: self)
    }
}
