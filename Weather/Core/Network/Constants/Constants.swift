//
//  Constants.swift
//  Weather
//
//  Created by Sharath on 10/10/24.
//

import Foundation

// MARK: - Constants
struct Constants {
    struct API {
        static let apiKey = "e5607e4454eb09c359fa3a26f1afb454"
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum Endpoint {
    case geoCode(city: String)
    case geoCodeCoordinate(lat: Double, lon: Double)
    case weatherReport(lat: Double, lon: Double)
    
    var url: String {
        switch self {
        case .geoCode(city: let city):
            return "http://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=5&appid=\(Constants.API.apiKey)"
        case .weatherReport(let lat, let lon):
            return "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(Constants.API.apiKey)"
        case .geoCodeCoordinate(let lat, let lon):
            return "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(Constants.API.apiKey)"
        }
    }
    
    var method: String {
        switch self {
        case .geoCode, .geoCodeCoordinate:
            return HTTPMethod.get.rawValue
        case .weatherReport:
            return HTTPMethod.post.rawValue
        }
    }
}


