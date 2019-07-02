//
//  Favorite.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 14/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class Favorite: NSManagedObject {
    
    static var favorite: [Favorite] { // Get an Array of favorite
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        guard let favorites = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return favorites
    }
    
    static func restorAllFavorites() -> Recipes { // Get all Favorite in a Struct Recipes
        var imagesFavorites: [UIImage] = []
        var hits: [Hits] = []
        
        for favorite in Favorite.favorite {
            imagesFavorites.append(self.restoreImageFavorite(favorite: favorite)) // Call a function restoreImageFavorite for get all images of recipes
            hits.append(self.reconstructStructRecette(recette: favorite.recipesFavorites!)) // Call a function reconstructSructRecette for get all recettes
        }
        return Recipes(recipes: CurrentRecipe(hits: hits), images: imagesFavorites)
    }
    
    private static func restoreImageFavorite(favorite: Favorite) -> UIImage { // Restore all Images of recettes
        guard let image = UIImage(data: favorite.imagesFavorites!.image!) else {
            return UIImage(named: "food.png")! // Return a default image if the recover failed
        }
        return image
    }
    
    private static func reconstructStructRecette(recette: RecipesFavorites) -> Hits { // Restore all recettes in a struct Hits
        return Hits(recipe: Recipe(label: recette.label!, image: "", ingredientLines: recette.listIngredients as! [String], calories: recette.calories, totalTime: recette.totalTime, yield: recette.yield))
    }
    
    func addElement(dataRecette: Hits, imageRecette: Data?) {
        self.addDataRecette(dataRecette: dataRecette) // Call a Function for add the recette
        self.addImageRecette(imageRecette: imageRecette) // Call a function for add the image
        Favorite.save() // Save the new favorite recette
    }
    
    private func addDataRecette(dataRecette: Hits) { // Add a the recette to favorite
        let data = RecipesFavorites(context: AppDelegate.viewContext) // Create an RecetteFavorite
        
        data.calories = dataRecette.recipe.calories // Fill RecetteFavorite
        data.label = dataRecette.recipe.label
        data.totalTime = dataRecette.recipe.totalTime
        data.yield = dataRecette.recipe.yield
        data.listIngredients = dataRecette.recipe.ingredientLines as NSObject
        self.recipesFavorites = data // Add RecetteFavorite to Favorite.recettesFavorites
    }
    
    private func addImageRecette(imageRecette: Data?) {
        let image = ImagesFavorites(context: AppDelegate.viewContext)
        
        guard (UIImage(data: imageRecette!) != nil) else {
            image.image = UIImage(named: "food.png")!.pngData() // Cast the image of recette in data
            return self.imagesFavorites = image
        }
        image.image = imageRecette! // Cast the image of recette in data
        self.imagesFavorites = image // // Add RecetteFavorite to Favorite.imagesFavorites
    }
    
    static func resetFavorite() {
        for favorite in Favorite.favorite {
           AppDelegate.viewContext.delete(favorite) // Delete all favorites
        }
       Favorite.save() // Save the changement
    }
    
    static func deleteElement(row: Int) { // Delete an element with index
        if (row > Favorite.favorite.count) {
            return
        }
        let element = Favorite.favorite[row]
        AppDelegate.viewContext.delete(element)
        Favorite.save()
    }
    
    static private func save() {
        do {
            try  AppDelegate.viewContext.save()
            NotificationCenter.default.post(name: .reloadFavoritesListRecipes, object: nil)
        } catch  {
            NotificationCenter.default.post(name: .error, object: ["Error Saving", "Can't save the data"])
        }
    }
}
