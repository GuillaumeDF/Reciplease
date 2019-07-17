//
//  FakeResponseAddIngredient.swift
//  RecipleaseTests
//
//  Created by Guillaume Djaider Fornari on 17/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation
@testable import Reciplease
import Alamofire

struct Request {
    let urlRequest: URLRequest
    let data: Data?
    let response: HTTPURLResponse
}

class FakeResponseAddIngredient: EdamamProtocol {
    
    var request: Request?
    let urlRequest = URLRequest(url: URL(string: "https://www.edamam.com/")!)
    var incorrectData: Data {
        let bundle = Bundle(for: FakeResponseAddIngredient.self)
        let url = bundle.url(forResource: "ResultFakeApiReciplease", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    var correctData: Data {
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
    
    func request(parameters: Parameters, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        let httpResponse = self.request?.response
        let data = self.request?.data
        let error = self.error
        
        let result = Alamofire.Request.serializeResponseJSON(options: .allowFragments, response: httpResponse, data: data, error: error)
        completionHandler(DataResponse(request: self.urlRequest, response: httpResponse, data: data, result: result))
    }
}
