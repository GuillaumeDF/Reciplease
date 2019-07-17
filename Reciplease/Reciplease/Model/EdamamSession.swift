//
//  EdamamSession.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 17/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation
import Alamofire

protocol EdamamProtocol {
    var urlApi: String { get }
    var idApi: String { get }
    var keyApi: String { get }
    func request(parameters: Parameters, completionHandler: @escaping (DataResponse<Any>) -> Void)
}

extension EdamamProtocol {
    var urlApi: String {
        return "https://api.edamam.com/search"
    }
    var idApi: String {
        return "5793f67a"
    }
    var keyApi: String {
        return "cae818758e2fe39a683ffd2bd89ff81a"
    }
}

class EdamamSession: EdamamProtocol {
    func request(parameters: Parameters, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        Alamofire.request(self.urlApi, parameters: parameters).responseJSON { responseData in
            completionHandler(responseData)
        }
    }
}
