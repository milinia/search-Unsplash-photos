//
//  NetworkManager.swift
//  search-app
//
//  Created by Evelina on 09.09.2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func makeRequest(with query: String) async throws -> Data
}

final class NetworkManager: NetworkManagerProtocol {
    
    // MARK: - Private properties
    private var publicAPIKey: String = "olTzeQgZLLd3Z8j8hsrQHzkf1VVaZZBKt6RkDaW-Hus"
    
    // MARK: - Implementation NetworkManagerProtocol
    func makeRequest(with query: String) async throws -> Data {
        do {
            guard let url = URL(string: query) else { throw URLError(.badURL) }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("Client-ID \(publicAPIKey)", forHTTPHeaderField: "Authorization")
            urlRequest.setValue("v1", forHTTPHeaderField: "Accept-Version")
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
            let (data, response) = try await session.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw AppError.connectionError}
            return data
        } catch {
            throw error
        }
    }
}
