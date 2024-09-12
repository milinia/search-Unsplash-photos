//
//  AppError.swift
//  search-app
//
//  Created by Evelina on 10.09.2024.
//

import Foundation

enum AppError: Error {
    case errorWhileDownloadingImage
    case connectionError
    case imageSaveError
    case coreDataError
}
