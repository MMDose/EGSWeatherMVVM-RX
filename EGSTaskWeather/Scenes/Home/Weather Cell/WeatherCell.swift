//
//  Weather Cell.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/26/20.
//

import UIKit

final class WeatherCell: UITableViewCell, ReuseIdentifiable {
    
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    
}
