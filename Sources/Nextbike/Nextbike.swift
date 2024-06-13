import Foundation

#if canImport(CoreLocation)
import struct CoreLocation.CLLocationCoordinate2D
#else
public struct CLLocationCoordinate2D: Decodable {
    public let latitude: Double
    public let longitude: Double
}
#endif

public struct Nextbike {
    private struct Root: Decodable {
        let countries: [Country]
    }
    
    @available(*, deprecated, renamed: "Nextbike.Maps.fetchBikesFor")
    public static func load(cityWithID cityID: Int,
                            session: URLSession = .shared,
                            completion: @escaping (Result<[Country], Error>) -> Void) {
        let url = URL(string: "https://api.nextbike.net/maps/nextbike-live.json?city=\(cityID)")!
        let task = session.dataTask(with: url) { data, _, error in
            guard error == nil,
                  let data = data
            else {
                completion(.failure(error!))
                return
            }

            let decoded: Root

            do {
                decoded = try JSONDecoder().decode(Root.self, from: data)
            } catch {
                completion(.failure(error))
                return
            }

            completion(.success(decoded.countries))
        }
        task.resume()
    }
    
    @available(*, deprecated, renamed: "Nextbike.Maps.fetchBikesFor")
    public static func findNearby(location: CLLocationCoordinate2D,
                                  session: URLSession = .shared,
                                  completion: @escaping (Result<[Place], Error>) -> Void) {
        let url = URL(string: "https://api.nextbike.net/maps/nextbike-live.json?lat=\(location.latitude)&lng=\(location.longitude)")!
        let task = session.dataTask(with: url) { data, _, error in
            guard error == nil,
                  let data = data
            else {
                completion(.failure(error!))
                return
            }

            let decoded: Root

            do {
                decoded = try JSONDecoder().decode(Root.self, from: data)
            } catch {
                completion(.failure(error))
                return
            }

            completion(.success(decoded.countries.flatMap({ country in
                country.cities.flatMap { city in
                    return city.places
                }
            })))
        }
        task.resume()
    }
}
