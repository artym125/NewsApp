//
//  NewsTabView.swift
//  NewsApp
//
//  Created by Ostap Artym on 15.06.2023.
//

import SwiftUI

struct NewsTabView: View {
    
    @StateObject var articleNewsVM = ArticleNewsViewModel()
    
    
    var body: some View {
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .refreshable {
                    loadTask()
                }
                .onAppear{
                    loadTask()

                }
                .navigationTitle(articleNewsVM.selectedCategory.text)
        }
    }
    @ViewBuilder
    private var overlayView: some View {
   
        switch articleNewsVM.phase {
        case .empty:
            ProgressView()
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No articles", image: nil)
        case .failure(let error):
            RetryView(text: error.localizedDescription) {
                loadTask()
        }
            
        default: EmptyView()
            
        }

    }
    
    private var articles: [Article] {
        if case let .success(articles) = articleNewsVM.phase {
            return articles
        } else {
            return []
        }
    }
    private func loadTask(){
        async {
            await articleNewsVM.loadArticles()
        }
    }
        
}


struct EmptyPlaceholderView: View {
    let text: String
    let image: Image?
    
    var body: some View{
        VStack(spacing: 8) {
            Spacer()
            if let image = self.image{
                image
                    .imageScale(.large)
                    .font(.system(size: 50))
            }
            Text(text)
            Spacer()
        }
    }
}

struct RetryView: View {
    let text:String
    let retryAction: () -> ()
    
    var body: some View {
        VStack(spacing: 8) {
            Text(text)
                .font(.callout)
                .multilineTextAlignment(.center)
            Button(action: retryAction) {
                Text("Try again")
            }
        }
    }
}

struct NewsTabView_Previews: PreviewProvider {
    static var previews: some View {
        NewsTabView(articleNewsVM: ArticleNewsViewModel(article: Article.previewData))
    }
}
