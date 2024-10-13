//
//  Weather.swift
//  Weather
//
//  Created by Sharath on 11/10/24.
//

import Foundation

struct WeatherResponse: Decodable {
    
    let coord : Coord?
    let weather : [Weather]?
    let base : String?
    let main : Main?
    let visibility : Int?
    let wind : Wind?
    let clouds : Clouds?
    let dt : Int?
    let sys : Sys?
    let timezone : Int?
    let id : Int?
    let name : String?
    let cod : Int?
    
    init(coord : Coord?,
         weather : [Weather]?,
         base : String?,
         main : Main?,
         visibility : Int?,
         wind : Wind?,
         clouds : Clouds?,
         dt : Int?,
         sys : Sys?,
         timezone : Int?,
         id : Int?,
         name : String?,
         cod : Int?) {
        self.name = name
        self.weather = weather
        self.coord = coord
        self.base = base
        self.main = main
        self.visibility = visibility
        self.wind = wind
        self.clouds = clouds
        self.dt = dt
        self.sys = sys
        self.timezone = timezone
        self.id = id
        self.cod = cod
    }

    struct Coord : Decodable {
        let lon : Double?
        let lat : Double?
    }
    struct Weather : Decodable {
        let id : Int?
        let main : String?
        let desc : String?
        let icon : String?
        enum CodingKeys: String, CodingKey {
            case id, desc = "description", main, icon
        }
    }
    struct Main : Decodable {
        let temp : Double?
        let feels_like : Double?
        let temp_min : Double?
        let temp_max : Double?
        let pressure : Int?
        let humidity : Int?
        let sea_level : Int?
        let grnd_level : Int?
    }
    struct Wind : Decodable {
        let speed : Double?
        let deg : Int?
        let gust : Double?
    }
    struct Clouds : Decodable {
        let all : Int?
    }
    struct Sys : Decodable {
        let type : Int?
        let id : Int?
        let country : String?
        let sunrise : Int?
        let sunset : Int?
    }
}

extension WeatherResponse {
    static func mock() -> WeatherResponse {
        return WeatherResponse.init(
            coord: Coord.init(lon: 10.0, lat: 10.0), weather: nil, base: nil, main: nil, visibility: nil, wind: nil, clouds: nil, dt: nil, sys: nil, timezone: nil, id: nil, name: "Stockhome", cod: nil)
    }
}
