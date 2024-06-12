//
//  NetworkManager.swift
//  NextbikePackageDescription
//
//  Created by Adrian Böhme on 12.06.24.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func request<T: Decodable>(_ endpoint: Endpoint,
                               session: URLSession = .shared,
                               completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method.rawValue
        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        if let body = endpoint.body {
            request.httpBody = body
        }

        let task = session.dataTask(with: request) { data, _, error in
            guard error == nil, let data = data else {
                completion(.failure(error!))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
