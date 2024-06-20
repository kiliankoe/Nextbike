//
//  Maps.swift
//  NextbikePackageDescription
//
//  Created by Adrian Böhme on 12.06.24.
//

import Foundation
import CoreLocation

extension Nextbike {
    public struct Maps {
        private struct Root: Decodable {
            let countries: [Country]
        }
        
        public static func fetchBikesFor(cityWithID cityID: Int,
                                         limit: Int? = nil,
                                         session: URLSession = .shared,
                                         completion: @escaping (Result<[Country], Error>) -> Void) {
            var queryItems = [
                URLQueryItem(name: "city", value: "\(cityID)"),
                
            ]
            if let l = limit {
                queryItems.append(URLQueryItem(name: "limit", value: "\(l)"))
            }
            
            let endpoint = Endpoint(path: "/maps/nextbike-live.json", queryItems: queryItems)
            NetworkManager.shared.request(endpoint, session: session, completion: { (result: Result<Root, Error>) in
                switch result {
                case .success(let root):
                    completion(.success(root.countries))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
        
        public static func fetchBikesFor(domains: [String],
                                         limit: Int? = nil,
                                         session: URLSession = .shared,
                                         completion: @escaping (Result<[Country], Error>) -> Void) {
            var queryItems = [
                URLQueryItem(name: "domains", value: "\(domains.joined(separator: ","))"),
                
            ]
            if let l = limit {
                queryItems.append(URLQueryItem(name: "limit", value: "\(l)"))
            }
            
            let endpoint = Endpoint(path: "/maps/nextbike-live.json", queryItems: queryItems)
            NetworkManager.shared.request(endpoint, session: session, completion: { (result: Result<Root, Error>) in
                switch result {
                case .success(let root):
                    completion(.success(root.countries))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
        
        public static func fetchBikesFor(location: CLLocationCoordinate2D,
                                         limit: Int = 100,
                                         distance: Int = 2000,
                                         session: URLSession = .shared,
                                         completion: @escaping (Result<[Country], Error>) -> Void) {
            let queryItems = [
                URLQueryItem(name: "lat", value: "\(location.latitude)"),
                URLQueryItem(name: "lng", value: "\(location.longitude)"),
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "diameter", value: "\(distance)")
            ]
            let endpoint = Endpoint(path: "/maps/nextbike-live.json", queryItems: queryItems)
            NetworkManager.shared.request(endpoint, session: session) { (result: Result<Root, Error>) in
                switch result {
                case .success(let root):
                    completion(.success(root.countries))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        private struct GeoJsonRoot: Decodable {
            let geojson: FlexzoneResponse
        }
        /// > Warning: Save the hash and use it as parameter for the next request
        /// > if nothing changed, the API returns 304 - Not Modified
        /// > and the previously obtained data should be used
        ///
        /// - Parameters:
        ///     - apiKey: Nextbike API Key
        ///     - hash: the hash of the previous request response (leave empty if this is the first request)
        ///     - domain: if you want to retrieve flexzones for a specific area (see: https://api.nextbike.net/api/doc.php?mode=classic-regular&apikey=#basic_ideas)
        public static func flexzones(apiKey: String,
                                     hash: String,
                                     domain: String? = nil,
                                     session: URLSession = .shared,
                                     completion: @escaping (Result<FlexzoneResponse, Error>) -> Void) {
            var queryItems = [
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "hash", value: hash),
                URLQueryItem(name: "show_errors", value: "1")
            ]
            if let d = domain {
                queryItems.append(URLQueryItem(name: "domain", value: d))
            }
            
            let endpoint = Endpoint(path: "/api/getFlexzones.json", queryItems: queryItems)
            NetworkManager.shared.request(endpoint, session: session) { (result: Result<GeoJsonRoot, Error>) in
                switch result {
                case .success(let root):
                    completion(.success(root.geojson))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

