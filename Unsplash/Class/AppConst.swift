//
//  AppConst.swift
//  Unsplash
//
//  Created by CubezyTech on 07/12/23.
//

struct AppConst {
   
    static let baseurl = "https://api.unsplash.com/"
    static let photoUrl = "photos"
    static let clinetid = "a82f6bf78409bb9e7f0921a410d9d693d06b98a2d5df9a9cdc8295ab3cb261c1"
    static let topics = "topics"
    static let search = "search/photos"
}

enum imagePathType {
    case cameraRoll
    case appStorage
    case phoneStorage
}
