//
//  SearchRequest+CoreDataProperties.swift
//  search-app
//
//  Created by Evelina on 11.09.2024.
//
//

import Foundation
import CoreData


extension SearchRequest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchRequest> {
        return NSFetchRequest<SearchRequest>(entityName: "SearchRequest")
    }

    @NSManaged public var request: String
    @NSManaged public var addedDate: Date

}

extension SearchRequest : Identifiable {

}
