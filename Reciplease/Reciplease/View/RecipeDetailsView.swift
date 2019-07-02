//
//  RecipeDetailsView.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 13/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class RecipeDetailsView: UIView {
    
    @IBOutlet weak var calorieRecipe: UILabel!
    @IBOutlet weak var titleRecipe: UILabel!
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var yieldRecipe: UILabel!
    @IBOutlet weak var timeRecipe: UILabel!
    @IBOutlet weak var viewIndication: UIView! {
        didSet { // Add corner and border White
            viewIndication.layer.cornerRadius = 5
            viewIndication.layer.borderWidth = 2.5
            viewIndication.layer.borderColor = UIColor.white.cgColor
            viewIndication.layer.masksToBounds = true
        }
    }
    
    func setDetailRecette(data: Hits, image: UIImage) {
        self.yieldRecipe.text = String(data.recipe.yield)
        self.timeRecipe.text = String(data.recipe.totalTime) + "m"
        self.imageRecipe.image = image
        self.titleRecipe.text = data.recipe.label
        self.calorieRecipe.text = String(Int(data.recipe.calories)) + " calories"
    }

}
