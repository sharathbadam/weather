//
//  UserDefaults.swift
//  Weather
//
//  Created by Sharath on 11/10/24.
//

import Foundation

class PersistanceManager {
    
    static let shared = PersistanceManager()
    init() {}
    
    func saveCoordinates(latitude: Double, longitude: Double) {
        let coordinates = ["latitude": latitude, "longitude": longitude]
        UserDefaults.standard.set(coordinates, forKey: "coordinates")
    }
    
    func fetchCoordinates() -> (latitude: Double?, longitude: Double?) {
        if let coordinates = UserDefaults.standard.dictionary(forKey: "coordinates") as? [String: Double] {
            let latitude = coordinates["latitude"]
            let longitude = coordinates["longitude"]
            return (latitude, longitude)
        }
        return (nil, nil)
    }
}
