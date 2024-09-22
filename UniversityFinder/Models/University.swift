//
//  University.swift
//  UniversityFinder
//
//  Created by bilal awan on 21/09/2024.
//

import Foundation

struct University: Decodable {
    let domains: [String]
    let name: String
    let alphaTwoCode: String
    let webPages: [String]
    let stateProvince: String?
    let country: String

    enum CodingKeys: String, CodingKey {
        case domains
        case name
        case alphaTwoCode = "alpha_two_code"
        case webPages = "web_pages"
        case stateProvince = "state-province"
        case country
    }
}
