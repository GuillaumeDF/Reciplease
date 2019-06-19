//
//  Favorie.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 14/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class Favorie: NSManagedObject {
    
    static var favorie: [Favorie] { // Get an Array of favorie
        let request: NSFetchRequest<Favorie> = Favorie.fetchRequest()
        guard let favories = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return favories
    }
    
    static func restorAllFavories() -> Recettes { // Get all Favorie in a Struct Recettes
        var imagesFavories: [UIImage] = []
        var hits: [Hits] = []
        
        for favorie in Favorie.favorie {
            imagesFavories.append(self.restoreImageFavorie(favorie: favorie)) // Call a function restoreImageFavorie for get all images of recettes
            hits.append(self.reconstructStructRecette(recette: favorie.recettesFavories!)) // Call a function reconstructSructRecette for get all recettes
        }
        return Recettes(recettes: CurrentRecettes(hits: hits), images: imagesFavories)
    }
    
    private static func restoreImageFavorie(favorie: Favorie) -> UIImage { // Restore all Images of recettes
        guard let image = UIImage(data: favorie.imagesFavories!.image!) else {
            return UIImage(named: "food.png")! // Return a default image if the recover failed
        }
        return image
    }
    
    private static func reconstructStructRecette(recette: RecettesFavories) -> Hits { // Restore all recettes in a struct Hits
        return Hits(recipe: Recipe(label: recette.label!, image: "", ingredientLines: recette.listIngredients as! [String], calories: recette.calories, totalTime: recette.totalTime, yield: recette.yield))
    }
    
    func addElement(dataRecette: Hits, imageRecette: UIImage) {
        self.addDataRecette(dataRecette: dataRecette) // Call a Function for add the recette
        self.addImageRecette(imageRecette: imageRecette) // Call a function for add the image
        Favorie.save() // Save the new favorie recette
    }
    
    private func addDataRecette(dataRecette: Hits) { // Add a the recette to favorie
        let data = RecettesFavories(context: AppDelegate.viewContext) // Create an RecetteFavorie
        
        data.calories = dataRecette.recipe.calories // Fill RecetteFavorie
        data.label = dataRecette.recipe.label
        data.totalTime = dataRecette.recipe.totalTime
        data.yield = dataRecette.recipe.yield
        data.listIngredients = dataRecette.recipe.ingredientLines as NSObject
        self.recettesFavories = data // Add RecetteFavorie to Favorie.recettesFavories
    }
    
    private func addImageRecette(imageRecette: UIImage) {
        let image = ImagesFavories(context: AppDelegate.viewContext)
        
        guard ((imageRecette.pngData()) != nil) else {
            image.image = UIImage(named: "food.png")!.pngData() // Cast the image of recette in data
            return self.imagesFavories = image
        }
        image.image = imageRecette.pngData() // Cast the image of recette in data
        self.imagesFavories = image // // Add RecetteFavorie to Favorie.imagesFavories
    }
    
    static func resetFavorie() {
        for favorie in Favorie.favorie {
           AppDelegate.viewContext.delete(favorie) // Delete all favories
        }
       Favorie.save() // Save the changement
    }
    
    static func deleteElement(row: Int) { // Delete an element with index
        if (row > Favorie.favorie.count) {
            return
        }
        let element = Favorie.favorie[row]
        AppDelegate.viewContext.delete(element)
        Favorie.save()
    }
    
    static private func save() {
        do {
            try  AppDelegate.viewContext.save()
            NotificationCenter.default.post(name: .reloadFavoriesListRecettes, object: nil)
        } catch  {
            NotificationCenter.default.post(name: .error, object: ["Error Saving", "Can't save the data"])
        }
    }
}
