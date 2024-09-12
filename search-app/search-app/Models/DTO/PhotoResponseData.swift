//
//  PhotoResponseData.swift
//  search-app
//
//  Created by Evelina on 12.09.2024.
//

import Foundation

struct PhotoResponseData: Codable {
    let id: String
    let createdAt: Date
    let width: Int
    let height: Int
    let downloads: Int
    let likes: Int
    let description: String?
    let exif: Exif?
    let location: Location?
    let tags: [Tag]
    let urls: Urls
    let links: ResultLinks
    let user: UserDetail
}

struct Exif: Codable {
    let name: String?
}

struct Location: Codable {
    let city: String?
    let country: String?
}

struct Tag: Codable {
    let title: String
}

struct UserDetail: Codable {
    let id: String
    let username: String
    let name: String
    let portfolioURL: String?
    let bio: String?
    let profileImage: ProfileImage?
    let links: UserLinks
    let location: String?
    let totalLikes: Int?
    let totalPhotos: Int
}
