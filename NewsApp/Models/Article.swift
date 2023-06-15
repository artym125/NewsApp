//
//  Article.swift
//  NewsApp
//
//  Created by Ostap Artym on 15.06.2023.
//

import Foundation

fileprivate let relativeDateFormatter = RelativeDateTimeFormatter()

struct Article {
    let source: Source
    
    let author: String?
    var authorString: String {
        author ?? ""
    }
    
    let title: String
    
    let description: String?
    var descriptionString: String {
        description ?? ""
    }
    let urlToImage: String?
    
    let url: String
    let publishedAt: Date
    
    var articleURL: URL {
        URL(string: url)!
    }
    var imageURL: URL? {
        guard let urlToImage = urlToImage else {
            return nil
        }
        return URL(string: urlToImage)
    }    // Повертає URL зображення, якщо воно є
    
    var captionText: String {
        "\(source.name) ∙—∙ \(relativeDateFormatter.localizedString(for: publishedAt, relativeTo: Date()))"
    }
}

extension Article: Codable {}
extension Article: Equatable {}
extension Article: Identifiable {
    var id: String {url}
}
extension Article {
    static var previewData: [Article] {
        let previewDataURL =
        Bundle.main.url(forResource: "newsFileJSON", withExtension: "json")!
        let data = try! Data(contentsOf: previewDataURL)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        let apiResponse = try!
        jsonDecoder.decode(APIResponse.self, from: data)
        return apiResponse.articles ?? []
    }
}/*
  Крім того, ми визначаємо статичну властивість previewData у extension Article, яка генерує дані для попереднього перегляду. Вона використовує локальний JSON-файл newsFileJSON.json для створення моделей статей з API.
  */

struct Source {
    let name: String
}
extension Source: Codable {}
extension Source: Equatable {}

