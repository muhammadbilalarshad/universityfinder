//
//  NetworkManager.swift
//  UniversityFinder
//
//  Created by bilal awan on 21/09/2024.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func fetchUniversities(for country: String, completion: @escaping (Result<[University], Error>) -> Void) {
        let countryEncoded = country.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? country
        let urlString = Constants.BaseURL + "/search?country=\(countryEncoded)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let universities = try JSONDecoder().decode([University].self, from: data)
                completion(.success(universities))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
