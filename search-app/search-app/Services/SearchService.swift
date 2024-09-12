//
//  SearchService.swift
//  search-app
//
//  Created by Evelina on 09.09.2024.
//

import Foundation

protocol SearchServiceProtocol {
    func searchPhoto(query: String, orderBy: OrderByFilter, page: Int) async throws -> PhotoSearchResponseData
}

final class SearchService: SearchServiceProtocol {
    // MARK: - Private properties
    private let networkManager: NetworkManagerProtocol
    private let jsonDecoder: JSONDecoder
    
    // MARK: - Init
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        self.jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX'"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    func searchPhoto(query: String, orderBy: OrderByFilter, page: Int) async throws -> PhotoSearchResponseData {
        do {
            let request = page > 1 ? RequestsAPI.searchPhotosByPage(query: query, page: page, orderBy: orderBy) :
            RequestsAPI.searchPhotos(query: query, orderBy: orderBy)
            let data = try await networkManager.makeRequest(with: request.url)
            let photosData = try jsonDecoder.decode(PhotoSearchResponseData.self, from: data)
            return photosData
        } catch {
            throw AppError.connectionError
        }
    }
}
