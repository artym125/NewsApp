//
//  ArticleSerchVM.swift
//  NewsApp
//
//  Created by Ostap Artym on 15.06.2023.
//

import SwiftUI

@MainActor
class ArticleSearchViewModel: ObservableObject {
    
    @Published var phase: DataFetchPhase<[Article]> = .empty
    @Published var searchQuery = ""
    private let newsAPI = NewsAPI.shared
    
    func searchArticle() async {
        if Task.isCancelled {return}
        
        let searchQuery = self.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        phase = .empty
        
        if searchQuery.isEmpty {
            return
        }
        do {
            if Task.isCancelled {return}
            let articles = try await newsAPI.search(for: searchQuery)
            phase = .success(articles)
        } catch {
            if Task.isCancelled {return}
            phase = .failure(error)
            
        }
    }
}
