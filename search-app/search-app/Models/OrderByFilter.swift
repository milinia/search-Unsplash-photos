//
//  OrderByFilter.swift
//  search-app
//
//  Created by Evelina on 12.09.2024.
//

import Foundation

enum OrderByFilter: Int {
    case relevant
    case latest
    
    var url: String{
        switch self {
        case .relevant:
            return "relevant"
        case .latest:
            return "latest"
        }
    }
    
    var text: String {
        switch self {
        case .relevant:
            return "By popularity"
        case .latest:
            return "By publication date"
        }
    }
}
