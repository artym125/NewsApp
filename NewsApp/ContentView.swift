//
//  ContentView.swift
//  NewsApp
//
//  Created by Ostap Artym on 15.06.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NewsTabView()
                .tabItem{
                    Label("News", systemImage: "newspaper")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
