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
    
    static var favorie: [Favorie] {
        let request: NSFetchRequest<Favorie> = Favorie.fetchRequest()
        guard let favories = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return favories
    }
    
    static func restorAllFavories() -> Recettes {
        var imagesFavories: [UIImage] = []
        var hits: [Hits] = []
        
        for favorie in Favorie.favorie {
            imagesFavories.append(self.restoreImageFavorie(favorie: favorie))
            hits.append(self.reconstructStructRecette(recette: favorie.recettesFavories!))
        }
        return Recettes(recettes: CurrentRecettes(hits: hits), images: imagesFavories)
    }
    
    private static func restoreImageFavorie(favorie: Favorie) -> UIImage {
        guard let image = UIImage(data: favorie.imagesFavories!.image!) else {
            return UIImage(named: "food.png")!
        }
        return image
    }
    
    private static func reconstructStructRecette(recette: RecettesFavories) -> Hits {
        let recipe = Recipe(label: recette.label!, image: "", ingredientLines: recette.listIngredients as! [String], calories: recette.calories, totalTime: recette.totalTime, yield: recette.yield)
        let hits = Hits(recipe: recipe)
        return hits
    }
    
    func addElement(dataRecette: Hits, imageRecette: UIImage) {
        self.addDataRecette(dataRecette: dataRecette)
        self.addImageRecette(imageRecette: imageRecette)
        Favorie.save()
    }
    
    private func addDataRecette(dataRecette: Hits) {
        let data = RecettesFavories(context: AppDelegate.viewContext)
        
        data.calories = dataRecette.recipe.calories
        data.label = dataRecette.recipe.label
        data.totalTime = dataRecette.recipe.totalTime
        data.yield = dataRecette.recipe.yield
        data.listIngredients = dataRecette.recipe.ingredientLines as NSObject
        self.recettesFavories = data
    }
    
    private func addImageRecette(imageRecette: UIImage) {
        let image = ImagesFavories(context: AppDelegate.viewContext)
        
        image.image = imageRecette.pngData()
        self.imagesFavories = image
    }
    
    static func resetFavorie() {
        for favorie in Favorie.favorie {
           AppDelegate.viewContext.delete(favorie)
        }
       Favorie.save()
    }
    
    static func deleteElement(row: Int) {
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
