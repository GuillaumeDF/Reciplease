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

var hitsOK: Hits {
    return Hits(recipe: Recipe(label: "Tarte à la tomate", image: "food.png", ingredientLines: ["Lemon,", "Cheese", "Pasta"], calories: 1234.0, totalTime: 12, yield: 3))
}

var hitsKO: Hits {
    return Hits(recipe: Recipe(label: "", image: "", ingredientLines: [], calories: 0, totalTime: 0, yield: 0))
}

class FavorieTest: XCTestCase {
    
    func testGetAddRecetteToFavorieWhenDataIsCorrectThenAddingShouldBeOK() {
        let favorie = Favorie(context: AppDelegate.viewContext)
        favorie.addElement(dataRecette: hitsOK, imageRecette: UIImage(named: "food.png")!)
        XCTAssertEqual(favorie.recettesFavories?.label, "Tarte à la tomate")
        XCTAssertEqual(favorie.imagesFavories?.image, UIImage(named: "food.png")?.pngData())
    }
    
    func testGetAddRecetteToFavorieWhenDataIsNotCorrectThenAddingShouldBeOK() {
        let favorie = Favorie(context: AppDelegate.viewContext)
        favorie.addElement(dataRecette: hitsKO, imageRecette: UIImage(named: "food.png")!)
        XCTAssertEqual(favorie.recettesFavories?.label, "")
        XCTAssertEqual(favorie.imagesFavories?.image, UIImage(named: "food.png")?.pngData())
    }
    
    func testResetAllFavoriesThenTheCountingShouldBeZero() {
        Favorie.resetFavorie()
        XCTAssertEqual(Favorie.favorie.count, 0)
    }
    
    func testRestorAllFavoriesWhenFavorieIsCorrectThenTheResultShouldBeOK() {
        self.testResetAllFavoriesThenTheCountingShouldBeZero()
        self.testGetAddRecetteToFavorieWhenDataIsCorrectThenAddingShouldBeOK()
        self.testGetAddRecetteToFavorieWhenDataIsCorrectThenAddingShouldBeOK()
        let recettes = Favorie.restorAllFavories()
        XCTAssertEqual(recettes.recettes.hits.count, 2)
        XCTAssertEqual(recettes.images.count, 2)
    }
    
    func testRestorAllFavoriesWhenFavorieIsNotCorrectThenTheResultShouldBeOK() {
        self.testResetAllFavoriesThenTheCountingShouldBeZero()
        self.testGetAddRecetteToFavorieWhenDataIsNotCorrectThenAddingShouldBeOK()
        self.testGetAddRecetteToFavorieWhenDataIsNotCorrectThenAddingShouldBeOK()
        let recettes = Favorie.restorAllFavories()
        XCTAssertEqual(recettes.recettes.hits.count, 2)
        XCTAssertEqual(recettes.images.count, 2)
    }
    
    func testDeleteElementWhenIndexIsNotCorrectThenDeletingShouldBeKO() {
        self.testResetAllFavoriesThenTheCountingShouldBeZero()
        self.testGetAddRecetteToFavorieWhenDataIsCorrectThenAddingShouldBeOK()
        self.testGetAddRecetteToFavorieWhenDataIsCorrectThenAddingShouldBeOK()
        Favorie.deleteElement(row: 10)
        XCTAssertEqual(Favorie.favorie.count, 2)
        XCTAssertEqual(Favorie.favorie.count, 2)
    }
    
    func testDeleteElementWhenIndexIsCorrectThenDeletingShouldBeOk() {
        self.testResetAllFavoriesThenTheCountingShouldBeZero()
        self.testGetAddRecetteToFavorieWhenDataIsCorrectThenAddingShouldBeOK()
        self.testGetAddRecetteToFavorieWhenDataIsCorrectThenAddingShouldBeOK()
        Favorie.deleteElement(row: 1)
        XCTAssertEqual(Favorie.favorie.count, 1)
        XCTAssertEqual(Favorie.favorie.count, 1)
    }
}
