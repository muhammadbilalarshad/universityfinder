//
//  UniversityListViewModel.swift
//  UniversityFinder
//
//  Created by bilal awan on 21/09/2024.
//

import Foundation

class UniversityListViewModel {
    private(set) var universities: [UniversityViewModel] = []

    func fetchUniversities(for country: String, completion: @escaping (Error?) -> Void) {
        NetworkManager.shared.fetchUniversities(for: country) { [weak self] result in
            switch result {
            case .success(let universities):
                self?.universities = universities.map { UniversityViewModel(university: $0) }
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}
