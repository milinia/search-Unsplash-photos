//
//  HistoryService.swift
//  search-app
//
//  Created by Evelina on 09.09.2024.
//

import Foundation
import CoreData
import UIKit

protocol HistoryServiceProtocol {
    func getSearchRequestHistory() throws -> [String]
    func saveSearchRequest(text: String) throws
    func clearSearchRequestsHistory() throws
}

final class HistoryCoreDataService: HistoryServiceProtocol {
    
    // MARK: - Private properties
    private let context: NSManagedObjectContext? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return nil}
        return appDelegate.persistentContainer.viewContext
    }()
    
    // MARK: - Implement HistoryServiceProtocol
    func getSearchRequestHistory() throws -> [String] {
        guard let unwrappedContext = context else { return [] }
        do {
            let requestResult = try unwrappedContext.fetch(SearchRequest.fetchRequest())
            return requestResult.sorted(by: {$0.addedDate > $1.addedDate}).map({$0.request})
        } catch {
            throw AppError.coreDataError
        }
    }
    
    func saveSearchRequest(text: String) throws {
        guard let unwrappedContext = context else { return }
        do {
            let request = SearchRequest.fetchRequest()
            request.predicate = NSPredicate(format: "request == %@", text)
            let requestResult = try unwrappedContext.fetch(request)
            if let searchRequest = requestResult.first {
                searchRequest.addedDate = Date()
                try unwrappedContext.save()
            } else {
                let newRequest = SearchRequest(context: unwrappedContext)
                newRequest.request = text
                newRequest.addedDate = Date()
                try unwrappedContext.save()
                
                let fetchAllRequests = try unwrappedContext.fetch(SearchRequest.fetchRequest())
                let sortedRequests = fetchAllRequests.sorted(by: { $0.addedDate < $1.addedDate })
                if sortedRequests.count > 5 {
                    let objectToDelete = sortedRequests.first
                    if let objectToDelete = objectToDelete {
                        unwrappedContext.delete(objectToDelete)
                        try unwrappedContext.save()
                    }
                }
            }
        } catch {
            throw AppError.coreDataError
        }
    }
    
    func clearSearchRequestsHistory() throws {
        guard let unwrappedContext = context else { return }
        do {
            let request = NSBatchDeleteRequest(fetchRequest: SearchRequest.fetchRequest())
            try unwrappedContext.execute(request)
            try unwrappedContext.save()
        } catch {
            throw AppError.coreDataError
        }
    }
}
