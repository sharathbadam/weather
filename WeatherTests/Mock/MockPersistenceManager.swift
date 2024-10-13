//
//  MockPersistenceManager.swift
//  WeatherTests
//
//  Created by Sharath on 13/10/24.
//

import Foundation

class MockPersistenceManager: PersistanceManager {
    init(mockCoordinates: (latitude: Double?, longitude: Double?)) {
        super.init()
        self.mockCoordinates = mockCoordinates
    }
    
    var mockCoordinates: (latitude: Double?, longitude: Double?) = (59.3293, 18.0686)
    
    override func fetchCoordinates() -> (latitude: Double?, longitude: Double?) {
        return mockCoordinates
    }
    
    override func saveCoordinates(latitude: Double, longitude: Double) {
        // Mock saving coordinates
    }
}
