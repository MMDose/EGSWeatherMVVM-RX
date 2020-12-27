//
//  WeatherModel.swift
//  EGSTaskWeather
//
//  Created by Dose on 12/25/20.
//

import UIKit

struct WeatherModel: Decodable {
    
    enum CondingKeys: String, CodingKey {
        case current = "current"
        case daily = "daily"
    }
    
    let current: CurrentWeather
    var daily: [Daily]
    
    struct CurrentWeather: Decodable {
        
        enum CodingKeys: String, CodingKey {
            case date = "dt"
            case sunrise = "sunrise"
            case sunset = "sunset"
            case temperature = "temp"
            case feelLike = "feels_like"
            case pressure = "pressure"
            case humidity = "humidity"
            case cloudsPercenetage = "clouds"
            case windSpeed = "wind_speed"
            case weather = "weather"
        }
        
        let date: Date
        let weatherDescription: [WeatherDescription]
        let sunrise: Date
        let sunset: Date
        let temperature: Float
        let feelLike: Float
        let pressure: Float
        let humidity: Float
        let cloudsPercentage: Float
        let windSpeed: Float

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let dateInterval = try container.decode(Float.self, forKey: .date)
            let sunriseDateInterval = try container.decode(Float.self, forKey: .sunrise)
            let sunsetDateInterval = try container.decode(Float.self, forKey: .sunset)
            let temperature = try container.decode(Float.self, forKey: .temperature)
            let feelLike = try container.decode(Float.self, forKey: .feelLike)
            let pressure = try container.decode(Float.self, forKey: .pressure)
            let humidity = try container.decode(Float.self, forKey: .humidity)
            let cloudsPercentage = try container.decode(Float.self, forKey: .cloudsPercenetage)
            let windSpeed = try container.decode(Float.self, forKey: .windSpeed)
            
            self.weatherDescription = try container.decode([WeatherDescription].self, forKey: .weather)
            self.date = Date(timeIntervalSince1970: TimeInterval(dateInterval))
            self.sunrise = Date(timeIntervalSince1970: TimeInterval(sunriseDateInterval))
            self.sunset = Date(timeIntervalSince1970: TimeInterval(sunsetDateInterval))
            self.temperature = temperature
            self.feelLike = feelLike
            self.pressure = pressure
            self.humidity = humidity
            self.cloudsPercentage = cloudsPercentage
            self.windSpeed = windSpeed
        }
    }
    
    struct WeatherDescription: Decodable {
   
        let main: String
        let description: String
        let icon: String
        
        var iconURL: URL {
            return URLBuilder.imageURL(for: icon)
        }
        
        var localizedDescription: String {
            return "\(main) - \(description)"
        }
    }
    
    struct Daily: Decodable {
        
        enum CodingKeys: String, CodingKey {
            case date = "dt"
            case temp = "temp"
            case min = "min"
            case max = "max"
            case weatherDescription = "weather"
        }
        
        let weekDay: String
        let temperatureMin: Float
        let temperatureMax: Float
        let weatherDescription: [WeatherDescription]
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let timeInterval = try container.decode(Float.self, forKey: .date)
            let nestedTempContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .temp)
            let min = try nestedTempContainer.decode(Float.self, forKey: .min)
            let max = try nestedTempContainer.decode(Float.self, forKey: .max)
            self.weatherDescription = try container.decode([WeatherDescription].self, forKey: .weatherDescription)
            self.weekDay = DateFormatter.getWeekDay(from: Date(timeIntervalSince1970: TimeInterval(timeInterval)))
            self.temperatureMin = min
            self.temperatureMax = max
        }
        
    }
    
    static func decode(from data: Data) throws -> WeatherModel  {
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(WeatherModel.self, from: data)
    }
}
