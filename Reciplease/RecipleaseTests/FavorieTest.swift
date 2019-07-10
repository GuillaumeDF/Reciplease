//
//  FavorieTest.swift
//  RecipleaseTests
//
//  Created by Guillaume Djaider Fornari on 19/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import XCTest
@testable import Reciplease
import UIKit

class FavoriteTest: XCTestCase {
    
    static var hitsOK: Hits {
        return Hits(recipe: Recipe(label: "Tarte à la tomate", image: "food.png", ingredientLines: ["Lemon,", "Cheese", "Pasta"], calories: 1234.0, totalTime: 12, yield: 3))
    }
    
    static var hitsKO: Hits {
        return Hits(recipe: Recipe(label: "", image: "", ingredientLines: [], calories: 0, totalTime: 0, yield: 0))
    }
    
    func testGetAddRecetteToFavorieWhenDataIsCorrectThenAddingShouldBeOK() {
        let favorie = Favorite(context: AppDelegate.viewContext)
        favorie.addElement(dataRecette: FavoriteTest.hitsOK, imageRecette: UIImage(named: "food.png")?.pngData())
        XCTAssertEqual(favorie.recipesFavorites?.label, "Tarte à la tomate")
        XCTAssertEqual(favorie.imagesFavorites?.image, UIImage(named: "food.png")?.pngData())
    }
    
    func testGetAddRecetteToFavorieWhenDataIsNotCorrectThenAddingShouldBeOK() {
        let favorie = Favorite(context: AppDelegate.viewContext)
        favorie.addElement(dataRecette: FavoriteTest.hitsKO, imageRecette: "".data(using: .utf8))
        XCTAssertEqual(favorie.recipesFavorites?.label, "")
        XCTAssertEqual(favorie.imagesFavorites?.image, "".data(using: .utf8))
    }
    
    func testResetAllFavoriesThenTheCountingShouldBeZero() {
        Favorite.resetFavorite()
        XCTAssertEqual(Favorite.favorite.count, 0)
    }
    
    func testRestorAllFavoriesWhenFavorieIsCorrectThenTheResultShouldBeOK() {
        self.testResetAllFavoriesThenTheCountingShouldBeZero()
        self.testGetAddRecetteToFavorieWhenDataIsCorrectThenAddingShouldBeOK()
        self.testGetAddRecetteToFavorieWhenDataIsCorrectThenAddingShouldBeOK()
        let recettes = Favorite.restorAllFavorites()
        XCTAssertEqual(recettes.recipes.hits.count, 2)
        XCTAssertEqual(recettes.images.count, 2)
    }
    
    func testRestorAllFavoriesWhenFavorieIsNotCorrectThenTheResultShouldBeOK() {
        self.testResetAllFavoriesThenTheCountingShouldBeZero()
        self.testGetAddRecetteToFavorieWhenDataIsNotCorrectThenAddingShouldBeOK()
        self.testGetAddRecetteToFavorieWhenDataIsNotCorrectThenAddingShouldBeOK()
        Favorite.favorite.first!.imagesFavorites?.image = "".data(using: .utf8)
        let recettes = Favorite.restorAllFavorites()
        XCTAssertEqual(recettes.recipes.hits.count, 2)
        XCTAssertEqual(recettes.images.count, 2)
    }
    
    func testDeleteElementWhenIndexIsNotCorrectThenDeletingShouldBeKO() {
        self.testResetAllFavoriesThenTheCountingShouldBeZero()
        self.testGetAddRecetteToFavorieWhenDataIsCorrectThenAddingShouldBeOK()
        self.testGetAddRecetteToFavorieWhenDataIsCorrectThenAddingShouldBeOK()
        Favorite.deleteElement(row: 10)
        XCTAssertEqual(Favorite.favorite.count, 2)
        XCTAssertEqual(Favorite.favorite.count, 2)
    }
    
    func testDeleteElementWhenIndexIsCorrectThenDeletingShouldBeOk() {
        self.testResetAllFavoriesThenTheCountingShouldBeZero()
        self.testGetAddRecetteToFavorieWhenDataIsCorrectThenAddingShouldBeOK()
        self.testGetAddRecetteToFavorieWhenDataIsCorrectThenAddingShouldBeOK()
        Favorite.deleteElement(row: 1)
        XCTAssertEqual(Favorite.favorite.count, 1)
        XCTAssertEqual(Favorite.favorite.count, 1)
    }
    
    func testFindFavorieWhenFavorieIsEmptyThenResultShouldBeKO() {
        self.testResetAllFavoriesThenTheCountingShouldBeZero()
        XCTAssertEqual(Favorite.favorite, [])
    }
}
