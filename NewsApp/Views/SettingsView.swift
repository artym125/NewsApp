//
//  SettingsView.swift
//  NewsApp
//
//  Created by Ostap Artym on 15.06.2023.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("showImage") private var showImage = false // Параметр для збереження налаштування показу картинки
    @AppStorage("isShareSheetEnabled") private var isShareSheetEnabled = false // Параметр для відображення/приховування кнопки поділу
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Settings") // Заголовок "Settings"
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                List {
                    Toggle("Show Image", isOn: $showImage) // Візуалізація перемикача для відображення/приховування картинки
                    Toggle("Enable Share Sheet", isOn: $isShareSheetEnabled) // Візуалізація перемикача для відображення/приховування кнопки поділу
                }
                .listStyle(.inset) // Стиль списку
            }
            .padding()
            .onChange(of: isShareSheetEnabled) { newValue in
                // Виконання дій при зміні значення isShareSheetEnabled
                if !newValue {
                    // Якщо isShareSheetEnabled == false, очищаємо URL
                    presentShareSheet(url: nil)
                }
            }
            .onAppear {
                // При відображенні екрану перевіряємо значення isShareSheetEnabled
                if !isShareSheetEnabled {
                    // Якщо isShareSheetEnabled == false, очищаємо URL
                    presentShareSheet(url: nil)
                }
            }
            .navigationTitle("") // Пустий заголовок навігаційної панелі
            .navigationBarHidden(true) // Приховування навігаційної панелі
        }
    }
    
    private func presentShareSheet(url: URL?) {
        guard let url = url else {
            // Якщо URL порожній, просто повертаємося
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .keyWindow?
            .rootViewController?
            .present(activityVC, animated: true)
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
