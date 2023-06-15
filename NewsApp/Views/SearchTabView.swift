//
//  SearchTabView.swift
//  NewsApp
//
//  Created by Ostap Artym on 15.06.2023.
//

import SwiftUI

struct SearchTabView: View {
    
    @StateObject var searchVM = ArticleSearchViewModel()
    @State private var isShowingCalendar = false
    
    var body: some View {
        NavigationView {
            VStack {
                ArticleListView(articles: articles)
                    .overlay(overlayView)
                    .navigationTitle("Search")
                
                HStack(spacing: 1) {
                    Button(action: { isShowingCalendar = true }) {
                        Image(systemName: "calendar")
                            .font(.system(size: 18))
                            .foregroundColor(.blue)
                            .frame(width: 24, height: 24)
                    }
                    .sheet(isPresented: $isShowingCalendar, content: {
                        CalendarView(searchVM: searchVM, startDate: $searchVM.startDate, endDate: $searchVM.endDate)
                    }) .padding(.trailing, 40)

                    Button(action: { cleanDates() }) {
                        Image(systemName: "arrow.clockwise.circle")
                            .font(.system(size: 18))
                            .foregroundColor(.blue)
                            .frame(width: 24, height: 24)
                    } .padding(.leading, 40)
                }
                .padding(.top, 8)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .searchable(text: $searchVM.searchQuery)
        .onChange(of: searchVM.searchQuery) { newValue in
            if newValue.isEmpty {
                searchVM.phase = .empty
            }
        }
        .onSubmit(of: .search, search)
    }


    
    private var articles: [Article] {
        if case .success(let articles) = searchVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch searchVM.phase {
        case .empty:
            if !searchVM.searchQuery.isEmpty {
                ProgressView()
            } else {
                EmptyPlaceholderView(text: "What to look for?", image: Image(systemName: "magnifyingglass.circle"))
            }
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No search result found", image: Image(systemName: "magnifyingglass"))
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: search)
        default: EmptyView()
        }
    }
    
    private func cleanDates() {
        searchVM.cleanDates()
        search()
    }

    
    private func search() {
        Task {
            await searchVM.searchArticle()
        }
    }
}




struct SearchTabView_Previews: PreviewProvider {
    static var previews: some View {
        SearchTabView()
    }
}
