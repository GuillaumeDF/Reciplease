//
//  AddIngredientTest.swift
//  RecipleaseTests
//
//  Created by Guillaume Djaider Fornari on 25/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import XCTest
@testable import Reciplease
import UIKit

class AddIngredientTest: XCTestCase {

    let ingredient = AddIngredient()
    var myData :Notification?
    
    static var correctData: Data? {
        let bundle = Bundle(for: AddIngredientTest.self)
        let url = bundle.url(forResource: "ResultApiReciplease", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static var incorrectData: Data? {
        let bundle = Bundle(for: AddIngredientTest.self)
        let url = bundle.url(forResource: "ResultFakeApiReciplease", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static var hitsOK: Hits {
        return Hits(recipe: Recipe(label: "Lemon Sorbet", image: "https://www.edamam.com/web-img/78e/78ef0e463d0aadbf2caf7b6237cd5f12.jpg", ingredientLines: ["500.0g caster sugar", "1 lemon , unwaxed, zested", "250 ml lemon juice (6-8 lemons)"], calories: 2025.74, totalTime: 0, yield: 6))
    }
    
    static var hitsKO: Hits {
        return Hits(recipe: Recipe(label: "", image: "food.png", ingredientLines: ["", "", ""], calories: -1, totalTime: -1, yield: -1))
    }

    @objc func receveDataFromNotification(notification: Notification) {
        self.myData = notification
    }
    
    func testAddIngredientWhenIngredientIsCorrectThenResultShouldBeOK() {
        ingredient.addIngredient(ingredient: "Lemon")
        XCTAssertEqual(ingredient.urlIngredient, "Lemon ")
        XCTAssertEqual(ingredient.arrayIngredients[0], "Lemon")
    }
    
    func testAddIngredientWhenIngredientIsAlreadyPickThenResultShoulBeUnknown() {
        ingredient.addIngredient(ingredient: "Lemon")
        ingredient.addIngredient(ingredient: "Lemon")
        XCTAssertEqual(ingredient.urlIngredient, "Lemon ")
        XCTAssertEqual(ingredient.arrayIngredients[0], "Lemon")
    }
    
    func testGetReponseJsonWhenJsonIsCorrectThenResultShoultBeOK() {
        ingredient.getResponseJSON(data: AddIngredientTest.correctData)
        XCTAssertEqual((ingredient.dataRecipe?.recipes.hits.first?.recipe.label)!, AddIngredientTest.hitsOK.recipe.label)
        XCTAssertEqual((ingredient.dataRecipe?.recipes.hits.first?.recipe.image)!, AddIngredientTest.hitsOK.recipe.image)
        XCTAssertEqual((ingredient.dataRecipe?.recipes.hits.first?.recipe.ingredientLines)!, AddIngredientTest.hitsOK.recipe.ingredientLines)
        XCTAssertEqual((ingredient.dataRecipe?.recipes.hits.first?.recipe.calories)!, AddIngredientTest.hitsOK.recipe.calories)
        XCTAssertEqual((ingredient.dataRecipe?.recipes.hits.first?.recipe.totalTime)!, AddIngredientTest.hitsOK.recipe.totalTime)
        XCTAssertEqual((ingredient.dataRecipe?.recipes.hits.first?.recipe.yield)!, AddIngredientTest.hitsOK.recipe.yield)
        XCTAssertEqual((ingredient.dataRecipe?.images.first?.pngData())!, UIImage(data: try Data(contentsOf: URL(string: AddIngredientTest.hitsOK.recipe.image)!))?.pngData())
    }
    
    func testGetReponseJsonWhenJsonIsNotCorrectThenResultShoultBeKO() {
        ingredient.getResponseJSON(data: AddIngredientTest.incorrectData)
        XCTAssertEqual((ingredient.dataRecipe?.recipes.hits.first?.recipe.label)!, AddIngredientTest.hitsKO.recipe.label)
        XCTAssertEqual((ingredient.dataRecipe?.recipes.hits.first?.recipe.image)!, "")
        XCTAssertEqual((ingredient.dataRecipe?.recipes.hits.first?.recipe.ingredientLines)!, AddIngredientTest.hitsKO.recipe.ingredientLines)
        XCTAssertEqual((ingredient.dataRecipe?.recipes.hits.first?.recipe.calories)!, AddIngredientTest.hitsKO.recipe.calories)
        XCTAssertEqual((ingredient.dataRecipe?.recipes.hits.first?.recipe.totalTime)!, AddIngredientTest.hitsKO.recipe.totalTime)
        XCTAssertEqual((ingredient.dataRecipe?.recipes.hits.first?.recipe.yield)!, AddIngredientTest.hitsKO.recipe.yield)
        XCTAssertEqual((ingredient.dataRecipe?.images.first?.pngData())!, UIImage(named: "food.png")?.pngData())
    }
    
    func testGetReponseJsonWhenJsonIsNulThenResultShoultBeKO() {
        NotificationCenter.default.addObserver(self, selector: #selector(receveDataFromNotification), name: .error, object: nil)
        
        ingredient.getResponseJSON(data: nil)
        XCTAssertEqual("Error Decoder", (self.myData?.object as! [String])[0])
    }
    
    func testClearAllParametersWhenParametersIsNotEmptyThenCountingShouldBeZero() {
        ingredient.addIngredient(ingredient: "Lemon")
        ingredient.addIngredient(ingredient: "Cheese")
        ingredient.clearIngredients()
        XCTAssertEqual(ingredient.arrayIngredients.count, 0)
    }
    
    func testRemoveOneElementWhenParametersIsNotEmptyThenResultShouldBeOk() {
        ingredient.clearIngredients()
        ingredient.addIngredient(ingredient: "Lemon")
        ingredient.addIngredient(ingredient: "Cheese")
        ingredient.removeIngredient(index: 0)
        XCTAssertEqual(ingredient.arrayIngredients.first, "Cheese")
    }
    
    func testRemoveOneElementWhenIndexIsNotCorrectThenResultShouldBeKO() {
        NotificationCenter.default.addObserver(self, selector: #selector(receveDataFromNotification), name: .error, object: nil)
        
        ingredient.clearIngredients()
        ingredient.addIngredient(ingredient: "Lemon")
        ingredient.addIngredient(ingredient: "Cheese")
        ingredient.removeIngredient(index: 3)
        XCTAssertEqual("Bad Index", (self.myData?.object as! [String])[0])
    }
    
    func testReturnParameterWhenIngredientIsNotEmptyThenReusltShouldBeOk() {
        ingredient.clearIngredients()
        ingredient.addIngredient(ingredient: "Lemon")
        let index = ingredient.parameters.index(forKey: "q")
        XCTAssertEqual(ingredient.parameters[index!].value as! String, "Lemon ")
    }
    
    func testReturnParameterWhenIngredientIsEmptyThenReusltShouldBeEmpty() {
        ingredient.clearIngredients()
        let index = ingredient.parameters.index(forKey: "q")
        XCTAssertEqual(ingredient.parameters[index!].value as! String, "")
    }
    
}
