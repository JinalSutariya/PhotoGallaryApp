//
//  PopullarImage.swift
//  Unsplash
//
//  Created by CubezyTech on 08/12/23.
//

import Foundation
// MARK: - SearchImage
struct UnsplashSearchResponse: Codable {
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Codable {
    let id: String
    let urls: UnsplashPhotoURLs
}

struct UnsplashPhotoURLs: Codable {
    let regular: String
}
