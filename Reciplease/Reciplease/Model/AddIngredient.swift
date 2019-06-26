//
//  AddIngredient.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 11/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation
import Alamofire

internal let urlApi:    String! = "https://api.edamam.com/search"
internal let idApi:     String! = "5793f67a"
internal let keyApi:    String! = "cae818758e2fe39a683ffd2bd89ff81a"


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

// Struct used by JSONDecoder() for decode Data
struct CurrentRecettes: Codable {
    var hits: [Hits]
}

// Container used to transfer data between Controller
struct Recettes {
    var recettes: CurrentRecettes
    var images: [UIImage]
}

// Class used to create request, get Data and decode Data in JSON
class AddIngredient {
    var arrayIngredients: [String] = [] // Array of ingredients add by the user
    var urlIngredient: String = ""
    var parameters: Parameters { // Struct Parameters used by Alamodire for create a requete
        return ["q": self.urlIngredient,
                "app_id": idApi!,
                "app_key": keyApi!]
        }
    var dataRecette: Recettes?
    
    func addIngredient(ingredient: String) { // New ingredient in the list
        if (self.arrayIngredients.contains(ingredient)) {
            return NotificationCenter.default.post(name: .error, object: ["Error Ingredient", "This ingredients is already picked"])
        }
        self.addUrlIngredient(ingredient: ingredient)
        self.arrayIngredients.append(ingredient)
    }
    
    private func addUrlIngredient(ingredient: String) { // Transform array of ingredients in on line
            self.urlIngredient += ("\(ingredient) ")
    }
    
    func clearIngredients() { // Remove all of the user's list
        self.urlIngredient.removeAll()
        self.arrayIngredients.removeAll()
    }
    
    func removeIngredient(index: Int) { // Remove one ingredient in the list
        if index > self.arrayIngredients.count {
            return NotificationCenter.default.post(name: .error, object: ["Bad Index", "Can't remove an element"])
        }
        self.urlIngredient = self.urlIngredient.replacingOccurrences(of: "\(self.arrayIngredients[index]) ", with: "")
        self.arrayIngredients.remove(at: index)
    }
    
    func sendRequest() { // Send a request with Alamofire
         Alamofire.request(urlApi, parameters: self.parameters).responseJSON { response in
            if response.error != nil { // Check if there an error with response
                return NotificationCenter.default.post(name: .error, object: ["Error Data", "Can't recover Data from Api"])
            }
            if response.response?.statusCode != 200 { // Check if the response is 200
                return NotificationCenter.default.post(name: .error, object: ["Error Response", "Error Access from Api"])
            }
            self.getResponseJSON(data: response.data) // Call a function to decode in JSON
        }
    }
    
    func getResponseJSON(data: Data?) {
        do {
            // Decode with the struct CurrentRecettes
            let dataJSON = try JSONDecoder().decode(CurrentRecettes.self, from: data ?? "".data(using: .utf8)!)
            self.dataRecette = Recettes(recettes: dataJSON, images: self.getImages(recettes: dataJSON))
            NotificationCenter.default.post(name:.dataRecette, object: nil) // Send a notification for inform than the data is ready to display
        } catch {
            NotificationCenter.default.post(name: .error,object: ["Error Decoder", "Can't decode data in JSON"])
        }
    }
    
    private func getImages(recettes: CurrentRecettes) -> [UIImage] { // Download all images of recettes and stock in array
        var images: [UIImage] = []
        
        for urlImage in recettes.hits {
            if URL(string: urlImage.recipe.image) != nil {
                images.append(UIImage(data: try! Data(contentsOf: URL(string: urlImage.recipe.image)!))!)
            }
            else {
                images.append(UIImage(named: "food.png")!) // Download a default image if the recover failed
            }
        }
        return (images)
    }
}
