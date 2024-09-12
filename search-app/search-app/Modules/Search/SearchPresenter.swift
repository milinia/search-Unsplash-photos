//
//  SearchPresenter.swift
//  search-app
//
//  Created by Evelina on 09.09.2024.
//

import Foundation
import UIKit

protocol SearchPresenterProtocol {
    func clearSearchHistory()
    func makeFirstSearchRequest(request: String?, orderBy: OrderByFilter)
    func makeSearchRequestFromHistory(index: Int, orderBy: OrderByFilter)
    func makeSearchRequestByPage(request: String?, orderBy: OrderByFilter)
    func getSearchHistory() -> [String]
    func getPhotos() -> [PhotoResult]
    func downloadImage(imageURL: String, completion: @escaping ((UIImage, String) -> Void))
    func fetchSearchHistory()
    func openDetailView(index: Int)
    var sizes: [(Int, Int)] { get set }
}

final class SearchPresenter: SearchPresenterProtocol {
    
    //MARK: - Private properties
    private var totalPage: Int = 1
    private var currentPage: Int = 1
    private var isRequestExecuted: Bool = false
    private var photos: [PhotoResult] = []
    private var searchHistory: [String] = []
    
    private var searchService: SearchServiceProtocol
    private var imageService: ImageServiceProtocol
    private var historyService: HistoryServiceProtocol
    
    var sizes: [(Int, Int)] = []
    
    //MARK: - Public properties
    weak var view: SearchViewProtocol?
    var didTapToOpenDetail: ((String) -> Void)?
    
    //MARK: - Init
    init(searchService: SearchServiceProtocol, imageService: ImageServiceProtocol, historyService: HistoryServiceProtocol) {
        self.searchService = searchService
        self.imageService = imageService
        self.historyService = historyService
    }
    
    //MARK: - Implementation SearchPresenterProtocol
    func clearSearchHistory() {
        do {
            try historyService.clearSearchRequestsHistory()
        } catch {
            view?.showError()
        }
    }
    
    func makeFirstSearchRequest(request: String?, orderBy: OrderByFilter) {
        if let request = request, request != "" {
            currentPage = 1
            view?.showLoading()
            sizes = []
            do {
                try historyService.saveSearchRequest(text: request)
                Task {
                    let data = try await searchService.searchPhoto(query: request,
                                                                   orderBy: orderBy, page: 1)
                    photos = data.results
                    totalPage = data.totalPages
                    photos.forEach({sizes.append(($0.width, $0.height))})
                    view?.showSearchResult()
                }
            } catch {
                view?.showError()
            }
        }
    }
    
    func makeSearchRequestByPage(request: String?, orderBy: OrderByFilter) {
        if let request = request, request != "" {
            if !isRequestExecuted && currentPage < totalPage {
                isRequestExecuted = true
                currentPage += 1
                Task {
                    defer {
                        isRequestExecuted = false
                    }
                    do {
                        let data = try await searchService.searchPhoto(query: request,
                                                                       orderBy: orderBy, page: currentPage)
                        photos.append(contentsOf: data.results)
                        data.results.forEach({sizes.append(($0.width, $0.height))})
                        view?.updateSearchResult()
                    } catch {
                        view?.showError()
                    }
                }
            }
        }
    }
    
    func makeSearchRequestFromHistory(index: Int, orderBy: OrderByFilter) {
        makeFirstSearchRequest(request: searchHistory[index],
                               orderBy: orderBy)
    }
    
    func downloadImage(imageURL: String, completion: @escaping ((UIImage, String) -> Void)) {
        Task {
            let image = try await imageService.fetchImage(url: imageURL)
            completion(image, imageURL)
        }
    }
    
    func getSearchHistory() -> [String] {
        return searchHistory
    }
    
    func fetchSearchHistory()  {
        do {
            searchHistory = try historyService.getSearchRequestHistory()
            if !searchHistory.isEmpty {
                view?.showSearchHistory()
            }
        } catch {
            view?.showError()
        }
    }
    
    func getPhotos() -> [PhotoResult] {
        return photos
    }
    
    func openDetailView(index: Int) {
        didTapToOpenDetail?(photos[index].id)
    }
}
