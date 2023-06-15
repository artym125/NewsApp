//
//  Category.swift
//  NewsApp
//
//  Created by Ostap Artym on 15.06.2023.
//

import Foundation

enum Category: String, CaseIterable {
case general
case business
case technology
case sports
case enterteiment
case science
case health
    
    
    var text: String {
        if self == .general {
            return "Top headlines"
        } else {
            return rawValue.capitalized
        }
    }
}


extension Category:Identifiable {
    var id: Self {self}
}
