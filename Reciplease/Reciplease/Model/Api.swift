//
//  Api.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 11/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation

// 5793f67a
// cae818758e2fe39a683ffd2bd89ff81a
// https://api.edamam.com/search?q=chicken&app_id=5793f67a&app_key=cae818758e2fe39a683ffd2bd89ff81a&q=meat

internal let urlApi:    String! = "https://api.edamam.com/search"
internal let idApi:     String = "?app_id=5793f67a"
internal let keyApi:    String = "&app_key=cae818758e2fe39a683ffd2bd89ff81a"

class Api {
    var request: URLRequest!
    var url: String!
    var session = URLSession(configuration: .default)
    
    // This function is overrided in the others classes for set a specific url
    func createUrl() {
    }
    
    // Call some function for create a request and send it
    func newRequestGet() {
        self.createUrl()  // Call the function createUrl
        guard let url = URL(string: self.url) else {
            return NotificationCenter.default.post(name: .error, object: ["Error Url", "Can't construct URL"])
        }
        self.request = URLRequest(url: url) // Create a request
        self.request.httpMethod = "GET" // Set the metthod
        self.getData() // Call the function getData
    }
    
    // Get the data received
    private func getData() {
        // Create a task with the Url for get some Date
        let task = self.session.dataTask(with: self.request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else { // Get the data
                    return NotificationCenter.default.post(name: .error, object: ["Error Data", "Can't recover Data from Api"])
                }
                // Get the response server. 200 is Ok else is failed
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    return NotificationCenter.default.post(name: .error, object: ["Error Response", "Error Access from Api"])
                }
                self.getResponseJSON(data: data) // Call the function getResponseJSON for get the data converted into JSON
            }
        }
        task.resume()
    }
    
    // This function is overrided in the others classes for get the data into JSON
    func getResponseJSON(data: Data) {
    }
}
