//
//  AddIngredientTest.swift
//  RecipleaseTests
//
//  Created by Guillaume Djaider Fornari on 25/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import XCTest
@testable import Reciplease
import Alamofire

class AddIngredientTest: XCTestCase {
    var myData :Notification?
    let addIngredient = AddIngredient()
    let fakeSession = FakeResponseAddIngredient()
    
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
        addIngredient.addIngredient(ingredient: "Lemon")
        XCTAssertEqual(addIngredient.urlIngredient, "Lemon ")
        XCTAssertEqual(addIngredient.arrayIngredients[0], "Lemon")
    }
    
    func testAddIngredientWhenIngredientIsAlreadyPickThenResultShoulBeUnknown() {
        addIngredient.addIngredient(ingredient: "Lemon")
        addIngredient.addIngredient(ingredient: "Lemon")
        XCTAssertEqual(addIngredient.urlIngredient, "Lemon ")
        XCTAssertEqual(addIngredient.arrayIngredients[0], "Lemon")
    }
    
    func testGetReponseJsonWhenJsonIsCorrectThenResultShoultBeOK() {
        fakeSession.setRequest(dataIsCorrect: true)
        let fakeAddIngredient = AddIngredient(edamamSession: fakeSession)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeAddIngredient.sendRequest { dataRecipe in
            XCTAssertEqual((dataRecipe?.recipes.hits.first?.recipe.label)!, AddIngredientTest.hitsOK.recipe.label)
            XCTAssertEqual((dataRecipe?.recipes.hits.first?.recipe.image)!, AddIngredientTest.hitsOK.recipe.image)
            XCTAssertEqual((dataRecipe?.recipes.hits.first?.recipe.ingredientLines)!, AddIngredientTest.hitsOK.recipe.ingredientLines)
            XCTAssertEqual((dataRecipe?.recipes.hits.first?.recipe.calories)!, AddIngredientTest.hitsOK.recipe.calories)
            XCTAssertEqual((dataRecipe?.recipes.hits.first?.recipe.totalTime)!, AddIngredientTest.hitsOK.recipe.totalTime)
            XCTAssertEqual((dataRecipe?.recipes.hits.first?.recipe.yield)!, AddIngredientTest.hitsOK.recipe.yield)
            XCTAssertEqual(dataRecipe?.images.first, try! Data(contentsOf: URL(string: AddIngredientTest.hitsOK.recipe.image)!))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetReponseJsonWhenJsonIsNotCorrecAndResponseCodeIsOktThenResultShoultBeKO() {
        fakeSession.request = Request(urlRequest: fakeSession.urlRequest, data: fakeSession.incorrectData, response: fakeSession.responseOK)
        let fakeAddIngredient = AddIngredient(edamamSession: fakeSession)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeAddIngredient.sendRequest { dataRecipe in
            XCTAssertEqual((dataRecipe?.recipes.hits.first?.recipe.label)!, AddIngredientTest.hitsKO.recipe.label)
            XCTAssertEqual((dataRecipe?.recipes.hits.first?.recipe.image)!, "")
            XCTAssertEqual((dataRecipe?.recipes.hits.first?.recipe.ingredientLines)!, AddIngredientTest.hitsKO.recipe.ingredientLines)
            XCTAssertEqual((dataRecipe?.recipes.hits.first?.recipe.calories)!, AddIngredientTest.hitsKO.recipe.calories)
            XCTAssertEqual((dataRecipe?.recipes.hits.first?.recipe.totalTime)!, AddIngredientTest.hitsKO.recipe.totalTime)
            XCTAssertEqual((dataRecipe?.recipes.hits.first?.recipe.yield)!, AddIngredientTest.hitsKO.recipe.yield)
            XCTAssertEqual(dataRecipe?.images.first, "".data(using: .utf8))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetReponseJsonWhenJsonIsNilAndResponseCodeIsOktThenResultShoultBeKO() {
        fakeSession.request = Request(urlRequest: fakeSession.urlRequest, data: nil, response: fakeSession.responseOK)
        let fakeAddIngredient = AddIngredient(edamamSession: fakeSession)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeAddIngredient.sendRequest { dataRecipe in
            XCTAssertNil(dataRecipe)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetReponseJsonWhenJsonIsNotCorrecAndResponseCodeIsKOtThenResultShoultBeKO() {
        fakeSession.setRequest(dataIsCorrect: false)
        let fakeAddIngredient = AddIngredient(edamamSession: fakeSession)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeAddIngredient.sendRequest { dataRecipe in
            XCTAssertNil(dataRecipe)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testClearAllParametersWhenParametersIsNotEmptyThenCountingShouldBeZero() {
        addIngredient.addIngredient(ingredient: "Lemon")
        addIngredient.addIngredient(ingredient: "Cheese")
        addIngredient.clearIngredients()
        XCTAssertEqual(addIngredient.arrayIngredients.count, 0)
    }
    
    func testRemoveOneElementWhenParametersIsNotEmptyThenResultShouldBeOk() {
        addIngredient.clearIngredients()
        addIngredient.addIngredient(ingredient: "Lemon")
        addIngredient.addIngredient(ingredient: "Cheese")
        addIngredient.removeIngredient(index: 0)
        XCTAssertEqual(addIngredient.arrayIngredients.first, "Cheese")
    }
    
    func testRemoveOneElementWhenIndexIsNotCorrectThenResultShouldBeKO() {
        NotificationCenter.default.addObserver(self, selector: #selector(receveDataFromNotification), name: .error, object: nil)
        
        addIngredient.clearIngredients()
        addIngredient.addIngredient(ingredient: "Lemon")
        addIngredient.addIngredient(ingredient: "Cheese")
        addIngredient.removeIngredient(index: 3)
        XCTAssertEqual("Bad Index", (self.myData?.object as! [String])[0])
    }
    
    func testReturnParameterWhenIngredientIsNotEmptyThenReusltShouldBeOk() {
        addIngredient.clearIngredients()
        addIngredient.addIngredient(ingredient: "Lemon")
        let index = addIngredient.parameters.index(forKey: "q")
        XCTAssertEqual(addIngredient.parameters[index!].value as! String, "Lemon ")
    }
    
    func testReturnParameterWhenIngredientIsEmptyThenReusltShouldBeEmpty() {
        addIngredient.clearIngredients()
        let index = addIngredient.parameters.index(forKey: "q")
        XCTAssertEqual(addIngredient.parameters[index!].value as! String, "")
    }
}
