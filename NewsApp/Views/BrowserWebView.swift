//
//  BrowserWebView.swift
//  NewsApp
//
//  Created by Ostap Artym on 15.06.2023.
//

import Foundation
import SafariServices
import SwiftUI

struct SafariView: UIViewControllerRepresentable {
    
    let url:URL
    
    
    func makeUIViewController(context: Context) -> some SFSafariViewController {
        SFSafariViewController(url: url)
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context){
        
    }
}
