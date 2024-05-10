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

struct Root: Decodable {
    let countries: [Country]
}

public struct Country: Decodable {
    public let name: String
    public let cities: [City]

    private enum CodingKeys: String, CodingKey {
        case name = "country_name"
        case cities
    }
}

public struct City: Decodable {
    public let name: String
    public let places: [Place]
}

public struct Place: Decodable {
    public let coordinate: CLLocationCoordinate2D
    public let name: String
    public let isStation: Bool
    public let bikeCount: Int
    public let bookedBikeCount: Int

    private enum CodingKeys: String, CodingKey {
        case lat
        case lng
        case name
        case isStation = "spot"
        case bikeCount = "bikes"
        case bookedBikeCount = "booked_bikes"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let lat = try container.decode(Double.self, forKey: .lat)
        let lng = try container.decode(Double.self, forKey: .lng)
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        self.name = try container.decode(String.self, forKey: .name)
        self.bikeCount = try container.decode(Int.self, forKey: .bikeCount)
        self.isStation = try container.decode(Bool.self, forKey: .isStation)
        self.bookedBikeCount = try container.decode(Int.self, forKey: .bookedBikeCount)
    }
}
