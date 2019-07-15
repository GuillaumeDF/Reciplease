//
//  FavoriteOrNotTest.swift
//  RecipleaseTests
//
//  Created by Guillaume Djaider Fornari on 15/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import XCTest
@testable import Reciplease

class FavoriteOrNotTest: XCTestCase {
    
    func testIsFavoriteWhenPageIsNotFavoriteTheResultShouldBeisNotFavorite() {
        FavoriteOrNot().setFavoriteOrNot() { (callback) in
            XCTAssertEqual("isNotFavorite", callback)
        }
    }
    
    func testIsFavoriteWHenPageIsFavoriteAndTheyAreFavoritesThenResultSouldBeIsFavoriteAndFavorites() {
        let favorie = Favorite(context: AppDelegate.viewContext)
        favorie.addElement(dataRecette: FavoriteTest.hitsOK, imageRecette: UIImage(named: "food.png")?.pngData())
        FavoriteOrNot(title: "Favorie").setFavoriteOrNot() { (callback) in
            XCTAssertEqual("isFavoriteAndFavorites", callback)
        }
    }
    
    func testIsFavoriteWhenIsFavoriteAndTheyAreNoFavoriteThenResultShoultBeIsFavoriteAndNoFavorite() {
        Favorite.resetFavorite()
        FavoriteOrNot(title: "Favorie").setFavoriteOrNot() { (callback) in
            XCTAssertEqual("isFavoriteAndNoFavorite", callback)
        }
    }
}
