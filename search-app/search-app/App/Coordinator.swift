//
//  Coordinator.swift
//  search-app
//
//  Created by Evelina on 12.09.2024.
//

import Foundation
import UIKit

final class Coordinator {
    
    // MARK: - Private properties
    private let navigationController: UINavigationController
    private let assembly: AssemblyProtocol
    
    // MARK: - Init
    init(navigationController: UINavigationController, assembly: AssemblyProtocol) {
        self.navigationController = navigationController
        self.assembly = assembly
    }
    
    // MARK: - Public functions
    func start() {
        let presenter = SearchPresenter(searchService: assembly.searchService,
                                        imageService: assembly.imageService,
                                        historyService: assembly.historyService)
        let view = SearchViewController(presenter: presenter)
        presenter.view = view
        presenter.didTapToOpenDetail = openDetail
        navigationController.viewControllers = [view]
    }
    
    func openDetail(id: String) {
        let presenter = DetailPresenter(imageSaver: assembly.imageSaver,
                                        photoService: assembly.photoService,
                                        imageService: assembly.imageService)
        let view = DetailViewController(id: id, presenter: presenter)
        presenter.view = view
        navigationController.pushViewController(view, animated: true)
    }
}
