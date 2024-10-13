//
//  WeatherReportViewModel.swift
//  Weather
//
//  Created by Sharath on 11/10/24.
//

import Foundation

enum Temperature: Int {
    case farhenheit = 0
    case Celsius = 1
    case kelvin = 2
    
    var symbol: String {
        switch self {
        case .farhenheit: return "°F"
        case .Celsius: return "°C"
        case .kelvin: return "K"
        }
    }
}


class WeatherReportViewModel: NSObject, ObservableObject {
    
    @Published var temperatureScale: Temperature = .Celsius
    
    func temperature(value: Double?) -> String {
        if let value {
            if temperatureScale == .farhenheit {
                let fValue = (value - 273.15) * 9/5 + 32
                return "\(Int(fValue)) \(temperatureScale.symbol)"
            } else if temperatureScale == .Celsius {
                let cValue = value - 273.15
                return "\(Int(cValue)) \(temperatureScale.symbol)"
            } else {
                return "\(value) \(temperatureScale.symbol)"
            }
        } else {
            return "-- \(temperatureScale.symbol)"
        }
    }

    func timestampToDate(timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)

        // Initialize DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = TimeZone.current
        let formattedTime = dateFormatter.string(from: date)
        return formattedTime
    }    
}
