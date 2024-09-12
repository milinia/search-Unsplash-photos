//
//  DetailPresenter.swift
//  search-app
//
//  Created by Evelina on 11.09.2024.
//

import Foundation
import UIKit

protocol DetailPresenterProtocol {
    func getPhotoData(id: String)
    func saveImageToGallary(image: UIImage)
}

final class DetailPresenter: DetailPresenterProtocol {
    
    //MARK: - Private properties
    private var imageSaver: ImageSaverProtocol
    private let photoService: PhotoServiceProtocol
    private let imageService: ImageServiceProtocol
    
    //MARK: - Public properties
    weak var view: DetailViewProtocol?
    
    //MARK: - Init
    init(imageSaver: ImageSaverProtocol, photoService: PhotoServiceProtocol, imageService: ImageServiceProtocol) {
        self.imageSaver = imageSaver
        self.photoService = photoService
        self.imageService = imageService
        self.imageSaver.delegate = self
    }
    
    //MARK: - Implementation DetailPresenterProtocol
    func getPhotoData(id: String) {
        view?.showLoading()
        Task {
            do {
                let photoData = try await photoService.getPhotoById(id: id)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM d, yyyy"
                let formattedDate = dateFormatter.string(from: photoData.createdAt)
                let image = try await getImageByUrl(url: photoData.urls.full)
                let authorImage = try await getImageByUrl(url: photoData.user.profileImage?.medium)
                let photo = PhotoData(responseData: photoData,
                                      image: image ?? UIImage(),
                                      authorImage: authorImage ?? UIImage(),
                                      date: formattedDate)
                view?.updateViews(photoData: photo)
            } catch {
                view?.showError()
            }
        }
    }
    
    func saveImageToGallary(image: UIImage) {
        imageSaver.saveImage(image: image)
    }
    
    //MARK: - Private functions
    private func getImageByUrl(url: String?) async throws -> UIImage? {
        if let url = url {
            return try await imageService.fetchImage(url: url)
        }
        return nil
    }
}

extension DetailPresenter: ImageSaverDelegate {
    func didFinishSaving(error: AppError?) {
        if error != nil {
            view?.showAlert(error: error)
        } else {
            view?.showAlert(error: nil)
        }
    }
}
