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
        public static func fetchBikesFor(cityWithID cityID: Int,
                                session: URLSession = .shared,
                                completion: @escaping (Result<[Country], Error>) -> Void) {
            let endpoint = Endpoint(path: "/maps/nextbike-live.json?city=\(cityID)")
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
                                         session: URLSession = .shared,
                                         completion: @escaping (Result<[Place], Error>) -> Void) {
            let endpoint = Endpoint(path: "/maps/nextbike-live.json?lat=\(location.latitude)&lng=\(location.longitude)")
            NetworkManager.shared.request(endpoint, session: session) { (result: Result<Root, Error>) in
                switch result {
                case .success(let root):
                    let places = root.countries.flatMap { country in
                        country.cities.flatMap { city in
                            return city.places
                        }
                    }
                    completion(.success(places))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
