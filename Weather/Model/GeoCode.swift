//
//  GeocodeModel.swift
//  Weather
//
//  Created by Sharath on 10/10/24.
//

import Foundation

struct GeoCode: Decodable, Identifiable {
    let id = UUID()
    let name: String
    let localNames: [String: String]?
    let lat: Double
    let lon: Double
    let country: String?
    let state: String?
    
    enum CodingKeys: String, CodingKey {
        case name, localNames = "local_names", lat, lon, country, state
    }
}
