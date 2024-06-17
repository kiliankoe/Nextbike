//
//  City.swift
//  NextbikePackageDescription
//
//  Created by Adrian Böhme on 12.06.24.
//

import Foundation

public struct City: Decodable {
    public let name: String
    public let places: [Place]
}
