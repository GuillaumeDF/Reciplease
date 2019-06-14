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
    
    func addElement(dataRecette: Hits, imageRecette: UIImage) {
        self.addDataRecette(dataRecette: dataRecette)
        self.addImageRecette(imageRecette: imageRecette)
        do {
            try  AppDelegate.viewContext.save()
        } catch  {
            print("error")
        }
    }
    
    private func addDataRecette(dataRecette: Hits) {
        let data = RecettesFavories(context: AppDelegate.viewContext)
        
        data.calories = dataRecette.recipe.calories
        data.label = dataRecette.recipe.label
        data.totalTime = dataRecette.recipe.totalTime
        data.yield = dataRecette.recipe.yield
        self.recettesFavories = data
    }
    
    private func addImageRecette(imageRecette: UIImage) {
        let image = ImagesFavories(context: AppDelegate.viewContext)
        
        image.image = imageRecette.pngData()
        self.imagesFavories = image
    }
    
    func resetFavorie() {
        for favorie in Favorie.favorie {
           managedObjectContext?.delete(favorie)
        }
        do {
            try  AppDelegate.viewContext.save()
        } catch  {
            print("error")
        }
    }
    
}
