//
//  UnsplashAPIClint.swift
//  Unsplash
//
//  Created by CubezyTech on 12/12/23.
//

import Foundation
class ModelManager {
    static let shared = ModelManager()
    
    private init() {}
    
    func fetchImages(query: String, page: Int, completion: @escaping ([Result]?) -> Void) {
        let clientId = "a82f6bf78409bb9e7f0921a410d9d693d06b98a2d5df9a9cdc8295ab3cb261c1"
        
        guard let url = URL(string: "https://api.unsplash.com/search/collections/?client_id=\(clientId)&query=\(query)&page=\(page)&per_page=20") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let collectionList = try decoder.decode(CollectionList.self, from: data)
                completion(collectionList.results)
                print(collectionList)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
class ItemManager {
    static let shared = ItemManager()
    
    private init() {}
    
    func fetchImages(page: Int, id: String, completion: @escaping ([ItemListDatum]?) -> Void) {
        let clientId = "a82f6bf78409bb9e7f0921a410d9d693d06b98a2d5df9a9cdc8295ab3cb261c1"
        
        guard let url = URL(string: "https://api.unsplash.com/collections/\(id)/photos?page=\(page)&per_page=30&client_id=\(clientId)") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let collectionList = try decoder.decode(ItemListData.self, from: data)
                completion(collectionList)
             //   print(collectionList)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
