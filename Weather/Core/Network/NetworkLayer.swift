//
//  NetworkLayer.swift
//  Weather
//
//  Created by Sharath on 10/10/24.
//

import Foundation

// MARK: - NetworkManager
class NetworkManager {
    
    static let shared = NetworkManager()
    
    init() {}
    
    func performRequest<T: Decodable>(endpoint: Endpoint, body: Data? = nil, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: endpoint.url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        
        if let body = body {
            request.httpBody = body
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Request failed with error: \(error.localizedDescription)")
                completion(.failure(.apiError(error.localizedDescription)))
                return
            }

            guard let data = data, error == nil else {
                completion(.failure(.noData))
                return
            }
            
            print("Body: \(String(data: data, encoding: .utf8) ?? "")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch (let error) {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
