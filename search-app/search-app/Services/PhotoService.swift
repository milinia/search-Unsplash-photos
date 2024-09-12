//
//  PhotoService.swift
//  search-app
//
//  Created by Evelina on 12.09.2024.
//

import Foundation

protocol PhotoServiceProtocol {
    func getPhotoById(id: String) async throws -> PhotoResponseData
}

final class PhotoService: PhotoServiceProtocol {
    
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
    
    // MARK: - Implementation PhotoServiceProtocol
    func getPhotoById(id: String) async throws -> PhotoResponseData {
        do {
            let data = try await networkManager.makeRequest(with: RequestsAPI.getPhotoById(id: id).url)
            let photoData = try jsonDecoder.decode(PhotoResponseData.self, from: data)
            return photoData
        } catch {
            throw AppError.connectionError
        }
    }
}
