//
//  PopullarImage.swift
//  Unsplash
//
//  Created by CubezyTech on 08/12/23.
//

import Foundation

// MARK: - SearchImage
struct SearchImage: Codable {
    let total, totalPages: Int
    let results: [Resulttt]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result
struct Resulttt: Codable {
    let id, slug: String
    let createdAt, updatedAt: Date
    let promotedAt: Date?
    let width, height: Int
    let color, blurHash: String
    let description: String?
    let altDescription: String
    let breadcrumbs: [Breadcrumbbb]
    let urls: Urlsss
    let links: ResultLinksss
    let likes: Int
    let likedByUser: Bool
    let currentUserCollections: [JSONAnyyy]
    let sponsorship: JSONNullll?
    let topicSubmissions: ResultTopicSubmissions
    let user: Userrr
    let tags: [Taggg]

    enum CodingKeys: String, CodingKey {
        case id, slug
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case promotedAt = "promoted_at"
        case width, height, color
        case blurHash = "blur_hash"
        case description
        case altDescription = "alt_description"
        case breadcrumbs, urls, links, likes
        case likedByUser = "liked_by_user"
        case currentUserCollections = "current_user_collections"
        case sponsorship
        case topicSubmissions = "topic_submissions"
        case user, tags
    }
}

// MARK: - Breadcrumb
struct Breadcrumbbb: Codable {
    let slug, title: String
    let index: Int
    let type: TypeEnum
}

enum TypeEnummm: String, Codable {
    case landingPage = "landing_page"
    case search = "search"
}

// MARK: - ResultLinks
struct ResultLinksss: Codable {
    let linksSelf, html, download, downloadLocation: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
        case downloadLocation = "download_location"
    }
}

// MARK: - Tag
struct Taggg: Codable {
    let type: TypeEnum
    let title: String
    let source: Source?
}

// MARK: - Source
struct Sourceee: Codable {
    let ancestry: Ancestry
    let title, subtitle, description, metaTitle: String
    let metaDescription: String
    let coverPhoto: CoverPhoto

    enum CodingKeys: String, CodingKey {
        case ancestry, title, subtitle, description
        case metaTitle = "meta_title"
        case metaDescription = "meta_description"
        case coverPhoto = "cover_photo"
    }
}

// MARK: - Ancestry
struct Ancestryyy: Codable {
    let type: Category
    let category, subcategory: Category?
}

// MARK: - Category
struct Categoryyy: Codable {
    let slug, prettySlug: String

    enum CodingKeys: String, CodingKey {
        case slug
        case prettySlug = "pretty_slug"
    }
}

// MARK: - CoverPhoto
struct CoverPhoto: Codable {
    let id, slug: String
    let createdAt, updatedAt: Date
    let promotedAt: Date?
    let width, height: Int
    let color, blurHash: String
    let description: String?
    let altDescription: String
    let breadcrumbs: [Breadcrumbbb]
    let urls: Urlsss
    let links: ResultLinksss
    let likes: Int
    let likedByUser: Bool
    let currentUserCollections: [JSONAnyyy]
    let sponsorship: JSONNullll?
    let topicSubmissions: CoverPhotoTopicSubmissions
    let premium, plus: Bool
    let user: Userrr

    enum CodingKeys: String, CodingKey {
        case id, slug
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case promotedAt = "promoted_at"
        case width, height, color
        case blurHash = "blur_hash"
        case description
        case altDescription = "alt_description"
        case breadcrumbs, urls, links, likes
        case likedByUser = "liked_by_user"
        case currentUserCollections = "current_user_collections"
        case sponsorship
        case topicSubmissions = "topic_submissions"
        case premium, plus, user
    }
}

// MARK: - CoverPhotoTopicSubmissions
struct CoverPhotoTopicSubmissions: Codable {
    let interiors, animals, currentEvents, wallpapers: CurrentEventsss?
    let people, spirituality, nature, texturesPatterns: CurrentEventsss?

    enum CodingKeys: String, CodingKey {
        case interiors, animals
        case currentEvents = "current-events"
        case wallpapers, people, spirituality, nature
        case texturesPatterns = "textures-patterns"
    }
}

// MARK: - CurrentEvents
struct CurrentEventsss: Codable {
    let status: Status
    let approvedOn: Date

    enum CodingKeys: String, CodingKey {
        case status
        case approvedOn = "approved_on"
    }
}

enum Statusss: String, Codable {
    case approved = "approved"
}

// MARK: - Urls
struct Urlsss: Codable {
    let raw, full, regular, small: String
    let thumb, smallS3: String

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}

// MARK: - User
struct Userrr: Codable {
    let id: String
    let updatedAt: Date
    let username, name, firstName: String
    let lastName, twitterUsername: String?
    let portfolioURL: String?
    let bio, location: String?
    let links: UserLinksss
    let profileImage: ProfileImageee
    let instagramUsername: String?
    let totalCollections, totalLikes, totalPhotos, totalPromotedPhotos: Int
    let acceptedTos, forHire: Bool
    let social: Socialll

    enum CodingKeys: String, CodingKey {
        case id
        case updatedAt = "updated_at"
        case username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case twitterUsername = "twitter_username"
        case portfolioURL = "portfolio_url"
        case bio, location, links
        case profileImage = "profile_image"
        case instagramUsername = "instagram_username"
        case totalCollections = "total_collections"
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalPromotedPhotos = "total_promoted_photos"
        case acceptedTos = "accepted_tos"
        case forHire = "for_hire"
        case social
    }
}

// MARK: - UserLinks
struct UserLinksss: Codable {
    let linksSelf, html, photos, likes: String
    let portfolio, following, followers: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes, portfolio, following, followers
    }
}

// MARK: - ProfileImage
struct ProfileImageee: Codable {
    let small, medium, large: String
}

// MARK: - Social
struct Socialll: Codable {
    let instagramUsername: String?
    let portfolioURL: String?
    let twitterUsername: String?
    let paypalEmail: JSONNullll?

    enum CodingKeys: String, CodingKey {
        case instagramUsername = "instagram_username"
        case portfolioURL = "portfolio_url"
        case twitterUsername = "twitter_username"
        case paypalEmail = "paypal_email"
    }
}

// MARK: - ResultTopicSubmissions
struct ResultTopicSubmissions: Codable {
    let nature, wallpapers, currentEvents: CurrentEventsss?
    let travel: Travel?

    enum CodingKeys: String, CodingKey {
        case nature, wallpapers
        case currentEvents = "current-events"
        case travel
    }
}

// MARK: - Travel
struct Travel: Codable {
    let status: String
}

// MARK: - Encode/decode helpers

class JSONNullll: Codable, Hashable {

    public static func == (lhs: JSONNullll, rhs: JSONNullll) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKeyyy: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAnyyy: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container: SingleValueEncodingContainer = container.nestedContainer(keyedBy: JSONCodingKey.self) as! SingleValueEncodingContainer
                try encode(to: &container, value: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container: SingleValueEncodingContainer = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) as! SingleValueEncodingContainer
                try encode(to: &container, value: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container: SingleValueEncodingContainer = encoder.container(keyedBy: JSONCodingKey.self) as! SingleValueEncodingContainer
            try JSONAny.encode(to: &container, value: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
