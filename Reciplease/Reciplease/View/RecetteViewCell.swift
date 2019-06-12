//
//  RecetteViewCell.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 11/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit
import Alamofire

class RecetteViewCell: UITableViewCell {

    @IBOutlet weak var imageRecette: UIImageView!
    @IBOutlet weak var titleRecette: UILabel!
    @IBOutlet weak var ingredientsRecette: UILabel!
    @IBOutlet weak var yieldRecette: UILabel!
    @IBOutlet weak var timeRecette: UILabel!
    @IBOutlet weak var viewIndications: UIView! {
        didSet {
            viewIndications.layer.cornerRadius = 5
            viewIndications.layer.borderWidth = 2.5
            viewIndications.layer.borderColor = UIColor.white.cgColor
            viewIndications.layer.masksToBounds = true
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
    
    func setRecetteCell(recette: Hits, image: UIImage) {
        self.imageRecette.image = image
        self.titleRecette.text = recette.recipe.label
        self.ingredientsRecette.text = recette.recipe.ingredientLines.joined(separator: ", ")
        self.timeRecette.text = String(recette.recipe.totalTime) + "m"
        self.yieldRecette.text = String(recette.recipe.yield)
    }
}
