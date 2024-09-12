//
//  Assembly.swift
//  search-app
//
//  Created by Evelina on 12.09.2024.
//

import Foundation

protocol AssemblyProtocol {
    var searchService: SearchServiceProtocol { get }
    var networkManager: NetworkManagerProtocol { get }
    var imageService: ImageServiceProtocol { get }
    var photoService: PhotoServiceProtocol { get }
    var historyService: HistoryServiceProtocol { get }
    var imageSaver: ImageSaverProtocol { get }
}

final class Assembly: AssemblyProtocol {
    lazy var networkManager: NetworkManagerProtocol = NetworkManager()
    lazy var searchService: SearchServiceProtocol = SearchService(networkManager: networkManager)
    lazy var imageService: ImageServiceProtocol = ImageService(networkManager: networkManager)
    lazy var photoService: PhotoServiceProtocol = PhotoService(networkManager: networkManager)
    lazy var historyService: HistoryServiceProtocol = HistoryCoreDataService()
    lazy var imageSaver: ImageSaverProtocol = ImageSaver()
}
