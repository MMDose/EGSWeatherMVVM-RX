//
//  SmallAlert.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/27/20.
//

import UIKit


//MARK: - SmallAlert

public typealias SmallAlertAction = ((UIView)->())?
final class SmallAlert {
    
    let title: String
    let message: String
    let actionTitle: String
    let action: SmallAlertAction
    var retrieve: (()->())? = nil
    
    init(title: String, message: String, actionTitle: String, action: SmallAlertAction, retriveAction: (()->())? = nil) {
        self.title = title
        self.message = message
        
        self.actionTitle = actionTitle
        self.action = action
        self.retrieve = retriveAction
    }
}


//MARK: - Static error messages.

extension SmallAlert {
    static func locationServicesUnavailableError(action: SmallAlertAction) -> SmallAlert {
        return SmallAlert(title: "Warning", message: "Application needs your location to show weather for your.", actionTitle: "Settings", action: action)
    }
    
    static func unAvailableWeatherError(action: SmallAlertAction) -> SmallAlert {
        return SmallAlert(title: "ERROR", message: "Failed to load data from storage and network, check your connection", actionTitle: "", action: action)
    }
}
