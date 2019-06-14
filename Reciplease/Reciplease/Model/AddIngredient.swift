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
    let totalTime: Int16
    let yield: Int16
}

struct Hits: Codable {
    let recipe: Recipe
}

struct CurrentRecettes: Codable {
    var hits: [Hits]
}

struct Recettes {
    var recettes: CurrentRecettes
    var images: [UIImage]
}

class AddIngredient {
    var arrayIngredients: [String] = []
    var urlIngredient: String = ""
    var parameters: Parameters = [:]
    var dataRecette: Recettes?
    
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
            let dataJSON = try JSONDecoder().decode(CurrentRecettes.self, from: data)
            self.dataRecette = Recettes(recettes: dataJSON, images: self.getImages(recettes: dataJSON))
            NotificationCenter.default.post(name:.dataRecette, object: nil)
        } catch {
            NotificationCenter.default.post(name: .error,object: ["Error Decoder", "Can't decode data in JSON"])
        }
    }
    
    private func getImages(recettes: CurrentRecettes) -> [UIImage] {
        var images: [UIImage] = []
        
        for urlImage in recettes.hits {
            if let imageRecette = try? Data(contentsOf: URL(string: urlImage.recipe.image)!) {
                images.append(UIImage(data: imageRecette as Data)!)
            }
            else {
                images.append(UIImage(named: "food.png")!)
            }
        }
       return (images)
    }
}
