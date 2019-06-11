//
//  AddIngredient.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 11/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation
import Alamofire

struct Recipe: Codable {
    let label: String
    let image: String
    let ingredientLines: [String]
    let calories: Double
    let totalWeight: Double
    let totalTime: Int
}

struct Hits: Codable {
    let recipe: Recipe
}

struct Recettes: Codable {
    //let count: Int
    let hits: [Hits]
}

class AddIngredient {
    var arrayIngredients: [String] = []
    var urlIngredient: String = ""
    var parameters: Parameters = [:]
    
    func addIngredient(ingredient: String) {
        if (self.arrayIngredients.contains(ingredient)) {
            return NotificationCenter.default.post(name: .error, object: ["Error Ingredient", "This ingredients is already picked"])
        }
        self.addUrlIngredient(ingredient: ingredient)
        self.arrayIngredients.append(ingredient)
    }
    
    private func addUrlIngredient(ingredient: String) {
            self.urlIngredient += ("\(ingredient) ")
    }
    
    func clearIngredients() {
        self.clearUrlIngredient()
        self.arrayIngredients.removeAll()
    }
    
    private func clearUrlIngredient() {
        self.urlIngredient.removeAll()
    }
    
    func removeIngredient(index: Int) {
        self.urlIngredient = self.urlIngredient.replacingOccurrences(of: "\(self.arrayIngredients[index]) ", with: "")
        self.arrayIngredients.remove(at: index)
    }
    
    func setParameters() {
        self.parameters  = [
            "q": self.urlIngredient,
            "app_id": "5793f67a",
            "app_key": "cae818758e2fe39a683ffd2bd89ff81a"
        ]
    }
    
    func sendRequest() {
        Alamofire.request(urlApi, parameters: self.parameters).responseJSON { response in
            if response.error != nil {
                return NotificationCenter.default.post(name: .error, object: ["Error Data", "Can't recover Data from Api"])
            }
            if response.response?.statusCode != 200 {
                return NotificationCenter.default.post(name: .error, object: ["Error Response", "Error Access from Api"])
            }
            self.getResponseJSON(data: response.data!)
        }
    }
    
    func getResponseJSON(data: Data) {
        do {
            // Use the struct CurrentWeather with the methode Decode
            let dataRecette = try JSONDecoder().decode(Recettes.self, from: data)
            print(dataRecette.hits.count)
            //self.getIconPNG()
            //NotificationCenter.default.post(name:.dataWeather, object: self.dataWeather)
        } catch {
            NotificationCenter.default.post(name: .error,object: ["Error Decoder", "Can't decode data in JSON"])
        }
    }
    
}
