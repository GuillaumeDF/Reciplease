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
import Alamofire

struct Request {
    let urlRequest: URLRequest
    let data: Data?
    let response: HTTPURLResponse
}

class FakeResponseAddIngredient: AddIngredient {
    
    var request: Request?
    let urlRequest = URLRequest(url: URL(string: "https://www.edamam.com/")!)
    var incorrectData: Data? {
        let bundle = Bundle(for: FakeResponseAddIngredient.self)
        let url = bundle.url(forResource: "ResultFakeApiReciplease", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    var correctData: Data? {
        let bundle = Bundle(for: FakeResponseAddIngredient.self)
        let url = bundle.url(forResource: "ResultApiReciplease", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    let responseKO = HTTPURLResponse(
        url: URL(string: "https://www.edamam.com/")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!
    let responseOK = HTTPURLResponse(
        url: URL(string: "https://www.edamam.com/")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!
    
    class RecipleaseError: Error {}
    let error = RecipleaseError()
    
    func setRequest(dataIsCorrect: Bool) {
        switch dataIsCorrect {
        case true:
            self.request = Request(urlRequest: self.urlRequest, data: self.correctData, response: responseOK)
        case false:
            self.request = Request(urlRequest: self.urlRequest, data: self.incorrectData, response: responseKO)
        }
    }
    
    override func sendRequest() {
        let result = Alamofire.Request.serializeResponseData(response: self.request?.response, data: self.request?.data, error: self.error)
        let data = Alamofire.DataResponse(request: self.urlRequest, response: self.request?.response, data: self.request?.data, result: result)
        self.getResponseJSON(data: data.data)
    }
}

class AddIngredientTest: XCTestCase {
    var myData :Notification?
    let fake = FakeResponseAddIngredient()
    
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
        fake.addIngredient(ingredient: "Lemon")
        XCTAssertEqual(fake.urlIngredient, "Lemon ")
        XCTAssertEqual(fake.arrayIngredients[0], "Lemon")
    }
    
    func testAddIngredientWhenIngredientIsAlreadyPickThenResultShoulBeUnknown() {
        fake.addIngredient(ingredient: "Lemon")
        fake.addIngredient(ingredient: "Lemon")
        XCTAssertEqual(fake.urlIngredient, "Lemon ")
        XCTAssertEqual(fake.arrayIngredients[0], "Lemon")
    }
    
    func testGetReponseJsonWhenJsonIsCorrectThenResultShoultBeOK() {
        fake.setRequest(dataIsCorrect: true)
        fake.sendRequest()
        XCTAssertEqual((fake.dataRecipe?.recipes.hits.first?.recipe.label)!, AddIngredientTest.hitsOK.recipe.label)
        XCTAssertEqual((fake.dataRecipe?.recipes.hits.first?.recipe.image)!, AddIngredientTest.hitsOK.recipe.image)
        XCTAssertEqual((fake.dataRecipe?.recipes.hits.first?.recipe.ingredientLines)!, AddIngredientTest.hitsOK.recipe.ingredientLines)
        XCTAssertEqual((fake.dataRecipe?.recipes.hits.first?.recipe.calories)!, AddIngredientTest.hitsOK.recipe.calories)
        XCTAssertEqual((fake.dataRecipe?.recipes.hits.first?.recipe.totalTime)!, AddIngredientTest.hitsOK.recipe.totalTime)
        XCTAssertEqual((fake.dataRecipe?.recipes.hits.first?.recipe.yield)!, AddIngredientTest.hitsOK.recipe.yield)
        XCTAssertEqual(fake.dataRecipe?.images.first, try Data(contentsOf: URL(string: AddIngredientTest.hitsOK.recipe.image)!))
    }
    
    func testGetReponseJsonWhenJsonIsNotCorrectThenResultShoultBeKO() {
        fake.setRequest(dataIsCorrect: false)
        fake.sendRequest()
        XCTAssertEqual((fake.dataRecipe?.recipes.hits.first?.recipe.label)!, AddIngredientTest.hitsKO.recipe.label)
        XCTAssertEqual((fake.dataRecipe?.recipes.hits.first?.recipe.image)!, "")
        XCTAssertEqual((fake.dataRecipe?.recipes.hits.first?.recipe.ingredientLines)!, AddIngredientTest.hitsKO.recipe.ingredientLines)
        XCTAssertEqual((fake.dataRecipe?.recipes.hits.first?.recipe.calories)!, AddIngredientTest.hitsKO.recipe.calories)
        XCTAssertEqual((fake.dataRecipe?.recipes.hits.first?.recipe.totalTime)!, AddIngredientTest.hitsKO.recipe.totalTime)
        XCTAssertEqual((fake.dataRecipe?.recipes.hits.first?.recipe.yield)!, AddIngredientTest.hitsKO.recipe.yield)
        XCTAssertEqual(fake.dataRecipe?.images.first, "".data(using: .utf8))
    }
    
    func testGetReponseJsonWhenJsonIsNulThenResultShoultBeKO() {
        NotificationCenter.default.addObserver(self, selector: #selector(receveDataFromNotification), name: .error, object: nil)
        
        fake.getResponseJSON(data: nil)
        XCTAssertEqual("Error Decoder", (self.myData?.object as! [String])[0])
    }
    
    func testClearAllParametersWhenParametersIsNotEmptyThenCountingShouldBeZero() {
        fake.addIngredient(ingredient: "Lemon")
        fake.addIngredient(ingredient: "Cheese")
        fake.clearIngredients()
        XCTAssertEqual(fake.arrayIngredients.count, 0)
    }
    
    func testRemoveOneElementWhenParametersIsNotEmptyThenResultShouldBeOk() {
        fake.clearIngredients()
        fake.addIngredient(ingredient: "Lemon")
        fake.addIngredient(ingredient: "Cheese")
        fake.removeIngredient(index: 0)
        XCTAssertEqual(fake.arrayIngredients.first, "Cheese")
    }
    
    func testRemoveOneElementWhenIndexIsNotCorrectThenResultShouldBeKO() {
        NotificationCenter.default.addObserver(self, selector: #selector(receveDataFromNotification), name: .error, object: nil)
        
        fake.clearIngredients()
        fake.addIngredient(ingredient: "Lemon")
        fake.addIngredient(ingredient: "Cheese")
        fake.removeIngredient(index: 3)
        XCTAssertEqual("Bad Index", (self.myData?.object as! [String])[0])
    }
    
    func testReturnParameterWhenIngredientIsNotEmptyThenReusltShouldBeOk() {
        fake.clearIngredients()
        fake.addIngredient(ingredient: "Lemon")
        let index = fake.parameters.index(forKey: "q")
        XCTAssertEqual(fake.parameters[index!].value as! String, "Lemon ")
    }
    
    func testReturnParameterWhenIngredientIsEmptyThenReusltShouldBeEmpty() {
        fake.clearIngredients()
        let index = fake.parameters.index(forKey: "q")
        XCTAssertEqual(fake.parameters[index!].value as! String, "")
    }
    
}
