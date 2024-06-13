//
//  Place.swift
//  NextbikePackageDescription
//
//  Created by Adrian Böhme on 12.06.24.
//

import Foundation
import CoreLocation

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
