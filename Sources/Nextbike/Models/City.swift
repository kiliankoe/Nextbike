//
//  City.swift
//  NextbikePackageDescription
//
//  Created by Adrian Böhme on 12.06.24.
//

import Foundation

public struct City: Decodable {
    public let id: Int
    public let lat: Double
    public let lng: Double
    public let name: String
    public let placeCount: Int
    public let places: [Place]
    public let returnToStationsOnly: Bool
    public let bikeTypes: [String: Int]
    // TODO: BOUNDS
    
    private enum CodingKeys: String, CodingKey {
        case id = "uid"
        case lat
        case lng
        case name
        case placeCount = "num_places"
        case places
        case returnToStationsOnly = "return_to_official_only"
        case bikeTypes = "bike_types"
    }
}
