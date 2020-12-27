//
//  StoryboardInitializable.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/25/20.
//

import UIKit


//MARK: - StoryboardInitializable

protocol StoryboardInitializable {
    /// View controller storyboard ID.
    static var viewControllerStoryboardID: String { get }
    
    /// Initializate controller from storyboard.
    /// - Parameter name: Storyboard name. 
    static func initFromStoryboard(name: String) -> Self
}

extension StoryboardInitializable where Self: UIViewController {
    
    static var viewControllerStoryboardID: String {
        return String(describing: Self.self)
    }
    
    static func initFromStoryboard(name: String) -> Self {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: viewControllerStoryboardID) as! Self
    }
}


// MARK: - ReuseIdentifiable

protocol ReuseIdentifiable {
    ///
    static func reuseIdentifier() -> String
}

extension ReuseIdentifiable {
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
}
