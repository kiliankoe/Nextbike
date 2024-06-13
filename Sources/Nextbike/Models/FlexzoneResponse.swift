//
//  FlexzoneResponse.swift
//  NextbikePackageDescription
//
//  Created by Adrian Böhme on 13.06.24.
//

import Foundation
import MapKit
import AnyCodable

public struct FlexzoneResponse: Decodable {
    let hash: String
    let geojson: [MKGeoJSONObject]
    
    private enum CodingKeys: String, CodingKey {
        case hash
        case geojson = "nodeValue"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hash = try container.decode(String.self, forKey: .hash)
        
        
        let dictionary: [String: AnyCodable] = try container.decode([String: AnyCodable].self, forKey: .geojson)
        let nodeValueData = try JSONEncoder().encode(dictionary)
        
        // Decode the Data into an array of MKGeoJSONObject
        geojson = try MKGeoJSONDecoder().decode(nodeValueData)
    }
}
