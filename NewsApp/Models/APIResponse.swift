//
//  APIResponse.swift
//  NewsApp
//
//  Created by Ostap Artym on 15.06.2023.
//

import Foundation

struct APIResponse: Decodable {
    // Модель API-відповіді
    let code: String?
    let message: String?
    //на випадок якщо API не спрацює
    
    let status: String
    let totalResults: Int? //якщо поверне error
    let articles: [Article]?
    
    
    
}
