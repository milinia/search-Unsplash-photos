//
//  ImageService.swift
//  search-app
//
//  Created by Evelina on 09.09.2024.
//

import Foundation
import UIKit

protocol ImageServiceProtocol {
    func fetchImage(url: String) async throws -> UIImage
}

final class ImageService: ImageServiceProtocol {
    
    // MARK: - Private properties
    private var imageCache = NSCache<NSString, UIImage>()
    private let networkManager: NetworkManagerProtocol
    
    // MARK: - Init
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    // MARK: - Implementation ImageServiceProtocol
    func fetchImage(url: String) async throws -> UIImage {
        let key = url as NSString
        if let image = imageCache.object(forKey: key) {
            return image
        } else {
            let data = try await networkManager.makeRequest(with: url)
            if let image = UIImage(data: data) {
                imageCache.setObject(image, forKey: key)
                return image
            } else {
                throw AppError.errorWhileDownloadingImage
            }
        }
    }
}
