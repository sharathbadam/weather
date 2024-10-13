//
//  MockNetworkManager.swift
//  WeatherTests
//
//  Created by Sharath on 13/10/24.
//

import Foundation

class MockNetworkManager: NetworkManager {
    var mockResult: Result<Any, NetworkError>?
    
    func performRequest<T>(endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        if let mockResult = mockResult as? Result<T, NetworkError> {
            completion(mockResult)
        }
    }
}
