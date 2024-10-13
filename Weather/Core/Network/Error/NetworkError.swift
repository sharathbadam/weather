//
//  NetworkError.swift
//  Weather
//
//  Created by Sharath on 10/10/24.
//

import Foundation

// MARK: - NetworkError
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
    case apiError(String)
    
    var message: String {
        switch self {
        case .invalidResponse:
            return NSLocalizedString("invalid_response", comment: "")
        case .noData:
            return NSLocalizedString("no_data", comment: "")
        case .decodingError:
            return NSLocalizedString("decoding_error", comment: "")
        case .apiError(let message):
            return message
        case .invalidURL:
            return NSLocalizedString("invalid_url", comment: "")
        }
    }
}
