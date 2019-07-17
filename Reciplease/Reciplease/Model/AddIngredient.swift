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

// Struct used by JSONDecoder() for decode Data
struct CurrentRecipe: Codable {
    var hits: [Hits]
}

// Container used to transfer data between Controller
struct Recipes {
    var recipes: CurrentRecipe
    var images: [Data]
}

// Class used to create request, get Data and decode Data in JSON
class AddIngredient {
    
    private let edamamSession: EdamamProtocol
    var arrayIngredients: [String] = [] // Array of ingredients add by the user
    var urlIngredient: String = ""
    var parameters: Parameters { // Struct Parameters used by Alamodire for create a requete
        return ["q": self.urlIngredient,
                "app_id": edamamSession.idApi,
                "app_key": edamamSession.keyApi]
        }
    
    init(edamamSession: EdamamProtocol = EdamamSession()) {
        self.edamamSession = edamamSession
    }
    
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
    
    func sendRequest(completionHandler: @escaping (Recipes?) -> Void) { // Send a request with Alamofire
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
        }
        edamamSession.request(parameters: self.parameters) { response in
            guard response.response?.statusCode == 200 else { // Check if the response is 200
                completionHandler(nil)
                return NotificationCenter.default.post(name: .error, object: ["Error Response", "Error Access from Api"])
            }
            self.getResponseJSON(data: response.data) { success, dataRecipe in
                if success {
                    completionHandler(dataRecipe)
                    return
                }
                else {
                    completionHandler(nil)
                    return NotificationCenter.default.post(name: .error,object: ["Error Decoder", "Can't decode data in JSON"])
                }
            }
        }
    }
    
    func getResponseJSON(data: Data?, completionHandler: @escaping (Bool, Recipes?) -> Void) {
        guard let dataJSON = data else {
            return completionHandler(false, nil)
        }
        do {
            // Decode with the struct CurrentRecipe
            let myData = try JSONDecoder().decode(CurrentRecipe.self, from: dataJSON)
            completionHandler(true, Recipes(recipes: myData, images: self.getImages(recipes: myData)))
        } catch {
            completionHandler(false, nil)
        }
    }
    
    private func getImages(recipes: CurrentRecipe) -> [Data] { // Download all images of recipes and stock in array
        var images: [Data] = []
        
        for urlImage in recipes.hits {
            if let url = URL(string: urlImage.recipe.image) {
                images.append(getDataImage(url: url))
            }
            else {
                images.append(getDataImage(url: URL(string: "food.png")!)) // Download a default image if the recover failed
            }
        }
        return (images)
    }
    
    private func getDataImage(url: URL) -> Data {
        var data: Data
        
        do {
            data = try Data(contentsOf: url)
        } catch {
            data = "".data(using: .utf8)!
        }
        return data
    }
}
