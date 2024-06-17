//
//  Country.swift
//  NextbikePackageDescription
//
//  Created by Adrian Böhme on 12.06.24.
//

import Foundation

public struct Country: Decodable {
    public let name: String
    public let cities: [City]

    private enum CodingKeys: String, CodingKey {
        case name = "country_name"
        case cities
    }
}
