//
//  NewsAPI.swift
//  NewsApp
//
//  Created by Ostap Artym on 15.06.2023.
//

import Foundation

struct NewsAPI {
    static let shared = NewsAPI()
    private init() {}
    
    private let apiKey = "284ddc633ae946f09d56eff7afef5cea"
    private let session = URLSession.shared
    private let jsonDecoder:JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func fetch(from category: Category) async throws -> [Article] {
        try await fetchArticles(from: generateNewsURL(from: category))
    }
    
    func search(for query: String, startDate: Date?, endDate: Date?) async throws -> [Article] {
        try await fetchArticles(from: generateSearchURL(from: query, startDate: startDate, endDate: endDate))
    }
    
    private func fetchArticles(from url: URL) async throws -> [Article] {
        let (data, response) = try await session.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw generateError(description: "Bad Response")
        }
        
        switch response.statusCode {
        case (200...299), (400...499):
            let apiResponse = try jsonDecoder.decode(APIResponse.self, from: data)
            if apiResponse.status == "ok" {
                return apiResponse.articles ?? []
            } else {
                throw generateError(description: apiResponse.message ?? "An error occured")
            }
        default:
            throw generateError(description: "A server error occured")
        }
    }
    
    private func generateSearchURL(from query: String, startDate: Date?, endDate: Date?) -> URL {
        var components = URLComponents(string: "https://newsapi.org/v2/everything")
        
        let apiKeyQueryItem = URLQueryItem(name: "apiKey", value: apiKey)
        let languageQueryItem = URLQueryItem(name: "language", value: "en")
        let queryQueryItem = URLQueryItem(name: "q", value: query)
        
        components?.queryItems = [apiKeyQueryItem, languageQueryItem, queryQueryItem]
        
        if let startDate = startDate, let endDate = endDate {
            let startDateQueryItem = URLQueryItem(name: "from", value: startDate.formattedString())
            let endDateQueryItem = URLQueryItem(name: "to", value: endDate.formattedString())
            components?.queryItems?.append(startDateQueryItem)
            components?.queryItems?.append(endDateQueryItem)
        }
        
        return components?.url ?? URL(string: "")!
    }
    
    private func generateNewsURL(from category: Category) -> URL {
        var components = URLComponents(string: "https://newsapi.org/v2/top-headlines")
        
        let apiKeyQueryItem = URLQueryItem(name: "apiKey", value: apiKey)
        let languageQueryItem = URLQueryItem(name: "language", value: "en")
        let categoryQueryItem = URLQueryItem(name: "category", value: category.rawValue)
        
        components?.queryItems = [apiKeyQueryItem, languageQueryItem, categoryQueryItem]
        
        return components?.url ?? URL(string: "")!
    }
    
    private func generateError(code: Int = 1, description: String) -> Error {
        NSError(domain: "NewsAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
}

extension Date {
    func formattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
