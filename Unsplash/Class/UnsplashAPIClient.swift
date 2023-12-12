//
//  UnsplashAPIClint.swift
//  Unsplash
//
//  Created by CubezyTech on 12/12/23.
//

import Foundation
class UnsplashAPI {
    static let clientID = "a82f6bf78409bb9e7f0921a410d9d693d06b98a2d5df9a9cdc8295ab3cb261c1"

    static func searchImages(query: String, page: Int, completion: @escaping (Result<[UnsplashPhoto], Error>) -> Void) {
        let urlString = "https://api.unsplash.com/search/photos/?client_id=\(clientID)&query=\(query)&page=\(page)&per_page=30"

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(UnsplashSearchResponse.self, from: data)
                    completion(.success(result.results))
                } catch {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
}
