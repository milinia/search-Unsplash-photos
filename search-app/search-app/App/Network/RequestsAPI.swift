//
//  RequestsAPI.swift
//  search-app
//
//  Created by Evelina on 09.09.2024.
//

import Foundation

enum RequestsAPI {
    case searchPhotos(query: String, orderBy: OrderByFilter)
    case searchPhotosByPage(query: String, page: Int, orderBy: OrderByFilter)
    case getPhotoById(id: String)
    
    var baseUrl: String {
        return "https://api.unsplash.com"
    }
    
    var url: String {
        switch self {
        case .searchPhotos(let query, let orderBy):
            return baseUrl + "/search/photos?query=\(query)&per_page=30&order_by=\(orderBy.url)"
        case .searchPhotosByPage(let query, let page, let orderBy):
            return baseUrl + "/search/photos?query=\(query)&per_page=30&order_by=\(orderBy.url)&page=\(page)"
        case .getPhotoById(let id):
            return baseUrl + "/photos/\(id)"
        }
    }
}
