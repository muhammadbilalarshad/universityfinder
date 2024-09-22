//
//  UniversityViewModel.swift
//  UniversityFinder
//
//  Created by bilal awan on 21/09/2024.
//

import Foundation
import CoreLocation

class UniversityViewModel {
    private let university: University
    var name: String { university.name }
    var domains: String { university.domains.joined(separator: ", ") }
    var countryCode: String { university.alphaTwoCode }
    var webPages: [String] { university.webPages }
    var stateProvince: String { university.stateProvince ?? "N/A" }
    var country: String { university.country }

    var isExpanded: Bool = false
    var coordinate: CLLocationCoordinate2D?

    init(university: University) {
        self.university = university
    }

    // Function to get coordinates
    func fetchCoordinates(completion: @escaping (Error?) -> Void) {
        var secondParameter = stateProvince
        if stateProvince == "N/A" {
            secondParameter = country
        }
        let address = "\(name), \(secondParameter)"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            if let location = placemarks?.first?.location {
                self?.coordinate = location.coordinate
                completion(nil)
            } else {
                completion(error)
            }
        }
    }
}
