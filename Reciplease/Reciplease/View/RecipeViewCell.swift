//
//  RecipeViewCell.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 11/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit
import Alamofire

class RecipeViewCell: UITableViewCell {

    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var titleRecipe: UILabel!
    @IBOutlet weak var ingredientsRecipe: UILabel!
    @IBOutlet weak var yieldRecipe: UILabel!
    @IBOutlet weak var timeRecipe: UILabel!
    @IBOutlet weak var viewIndications: UIView! {
        didSet { // Add corner and border White
            viewIndications.layer.cornerRadius = 5
            viewIndications.layer.borderWidth = 2.5
            viewIndications.layer.borderColor = UIColor.white.cgColor
            viewIndications.layer.masksToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setRecipeCell(recipe: Hits, image: UIImage) {
        self.imageRecipe.image = image
        self.titleRecipe.text = recipe.recipe.label
        self.ingredientsRecipe.text = recipe.recipe.ingredientLines.joined(separator: ", ")
        self.timeRecipe.text = String(recipe.recipe.totalTime) + "m"
        self.yieldRecipe.text = String(recipe.recipe.yield)
        self.layer.cornerRadius = 10
    }
}
