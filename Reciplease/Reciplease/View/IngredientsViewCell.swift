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
    var displayIngredient: String = "" {
        didSet {
            self.setIngredientCell(ingredient: displayIngredient)
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
    
    private func setIngredientCell(ingredient: String) {
        self.ingredientLabel.text = "- " + ingredient
    }

}
