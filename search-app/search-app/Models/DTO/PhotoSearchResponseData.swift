//
//  PhotoSearchResponseData.swift
//  search-app
//
//  Created by Evelina on 10.09.2024.
//

import Foundation

struct PhotoSearchResponseData: Codable {
    let total: Int
    let totalPages: Int
    let results: [PhotoResult]
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: Date
    let width: Int
    let height: Int
    let color: String
    let likes: Int
    let description: String?
    let user: User
    let urls: Urls
    let links: ResultLinks
}

struct User: Codable {
    let id: String
    let username: String
    let name: String
    let firstName: String
    let lastName: String?
    let instagramUsername: String?
    let twitterUsername: String?
    let portfolioURL: String?
    let profileImage: ProfileImage
    let links: UserLinks
}

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}

struct UserLinks: Codable {
    let linksSelf: String
    let html: String
    let photos, likes: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes
    }
}

struct Urls: Codable {
    let raw: String
    let full: String?
    let regular: String
    let small: String
    let thumb: String
}

struct ResultLinks: Codable {
    let linksSelf: String
    let html: String
    let download: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
    }
}
