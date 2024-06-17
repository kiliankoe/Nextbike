//
//  NetworkManager.swift
//  NextbikePackageDescription
//
//  Created by Adrian Böhme on 12.06.24.
//

import Foundation

enum NetworkError: Error {
    case notSuccessful(Int, String)
}

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

        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                completion(.failure(error!))
                return
            }
            
            if let httpResponse = (response as? HTTPURLResponse) {
                if httpResponse.statusCode != 200 {
                    let message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                    completion(.failure(NetworkError.notSuccessful(httpResponse.statusCode, message)))
                    return
                }
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch let error as DecodingError {
                   switch error {
                            case .typeMismatch(let key, let value):
                              print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
                            case .valueNotFound(let key, let value):
                              print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
                            case .keyNotFound(let key, let value):
                              print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
                            case .dataCorrupted(let key):
                              print("error \(key), and ERROR: \(error.localizedDescription)")
                            default:
                              print("ERROR: \(error.localizedDescription)")
                            }
                   
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
