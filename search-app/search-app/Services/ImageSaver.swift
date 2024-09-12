//
//  ImageSaver.swift
//  search-app
//
//  Created by Evelina on 11.09.2024.
//

import Foundation
import UIKit

protocol ImageSaverDelegate: AnyObject {
    func didFinishSaving(error: AppError?)
}

protocol ImageSaverProtocol {
    var delegate: ImageSaverDelegate? { get set }
    func saveImage(image: UIImage)
}

final class ImageSaver: NSObject, ImageSaverProtocol {
    
    // MARK: - Public properties
    weak var delegate: ImageSaverDelegate?
    
    // MARK: - Implementation ImageSaverProtocol
    func saveImage(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            delegate?.didFinishSaving(error: AppError.imageSaveError)
        } else {
            delegate?.didFinishSaving(error: nil)
        }
    }
}
