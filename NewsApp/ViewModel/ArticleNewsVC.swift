//
//  ArticleNewsVC.swift
//  NewsApp
//
//  Created by Ostap Artym on 15.06.2023.
//

import Foundation
import SwiftUI

enum DataFetchPhase<T> {
    case empty
    case success(T)
    case failure(Error)
}
@MainActor
class ArticleNewsViewModel:ObservableObject {

    @Published var phase = DataFetchPhase<[Article]>.empty
    @Published var selectedCategory: Category
    private let newsAPI = NewsAPI.shared
    
    init(article: [Article]? = nil, selectedCategory: Category = .general) {
        if let articles = article {
            self.phase = .success(articles)
        } else {
            self.phase = .empty
        }
        self.selectedCategory = selectedCategory
    }
    func loadArticles() async {
        phase = .empty
        do {
            let articles = try await newsAPI.fetch(from: selectedCategory)
            phase = .success(articles)
            
        } catch {
            phase = .failure(error)
        }
    }
}
