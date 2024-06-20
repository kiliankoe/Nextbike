//
//  Country.swift
//  NextbikePackageDescription
//
//  Created by Adrian Böhme on 12.06.24.
//

import Foundation

public struct Country: Decodable {
    public let lat: Double
    public let lng: Double
    public let name: String
    public let hotline: String
    public let domain: String
    public let language: String
    public let email: String
    public let timezone: String
    public let currency: String
    public let systemOperatorAddress: String
    public let country: String
    public let countryName: String
    
    public let terms: URL
    public let policy: URL
    public let website: URL
    public let pricing: URL
    public let faq: URL
    
    public let bookedBikes: Int
    public let setPointBikes: Int
    public let availableBikes: Int
    
    public let noRegistration: Bool
    
    public let cities: [City]
    
    private enum CodingKeys: String, CodingKey {
        case lat
        case lng
        case name
        case hotline
        case domain
        case language
        case email
        case timezone
        case currency
        case systemOperatorAddress = "system_operator_address"
        case country
        case countryName = "country_name"
        case terms
        case policy
        case website
        case pricing
        case faq = "faq_url"
        case bookedBikes = "booked_bikes"
        case setPointBikes = "set_point_bikes"
        case availableBikes = "available_bikes"
        case noRegistration = "no_registration"
        case cities
    }
}
