//
//  IngredientsViewCell.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 11/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class IngredientsViewCell: UITableViewCell {

    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var displayIngredientLabel: UILabel!
    
    var newIngredient: String = "" {
        didSet {
            self.setIngredientCell(label: ingredientLabel, ingredient:  newIngredient)
        }
    }
    
    var displayIngredient: String = "" {
        didSet {
            self.setIngredientCell(label: displayIngredientLabel, ingredient:  displayIngredient)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setIngredientCell(label: UILabel, ingredient: String) {
        label.text = "- " + ingredient
    }
}
