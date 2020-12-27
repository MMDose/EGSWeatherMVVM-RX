//
//  UIBundle+RedirectSettings.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/27/20.
//

import UIKit

extension UIApplication {
    
    /// Redirects application to iOS Settings. 
    func redirectSettings() {
        let url = URL(string:UIApplication.openSettingsURLString)
        if canOpenURL(url!){
            open(url!, options: [:], completionHandler: nil)
        }
    }
}
