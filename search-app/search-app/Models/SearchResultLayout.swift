//
//  SearchResultLayout.swift
//  search-app
//
//  Created by Evelina on 12.09.2024.
//

import Foundation

enum SearchResultLayout: Int {
    case oneColumn
    case twoColumns
    
    var imageName: String {
        switch self {
        case .oneColumn:
            return "square"
        case .twoColumns:
            return "square.split.2x2"
        }
    }
}
