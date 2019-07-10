//
//  FavoriteOrNot.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 05/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation

class FavoriteOrNot {
    
    let title: String
    var favoriteIsSelected: Bool = false
    
    init (title: String) {
        self.title = title
    }
    
    init() {
        self.title = ""
    }
    
    var isFavorite: Bool {
        return self.title == "Favorie"
    }
    
    private var noFavorite: Bool {
        return Favorite.favorite.count == 0
    }
    
    private var isFavoriteAndNoFavorite: Bool {
        return self.isFavorite && self.noFavorite
    }
    
    private var isFavoriteAndFavorites: Bool {
        return self.isFavorite && !self.noFavorite
    }
    
    func setFavoriteOrNot(callback: @escaping (String) -> Void) {
        switch true {
        case !self.isFavorite:
            callback("isNotFavorite")
        case self.isFavoriteAndFavorites:
            callback("isFavoriteAndFavorites")
        case self.isFavoriteAndNoFavorite:
            callback("isFavoriteAndNoFavorite")
        default:
            return
        }
    }
}
