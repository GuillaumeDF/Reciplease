//
//  RecetteDetails.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 13/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class RecetteDetails: UIView {
    
    @IBOutlet weak var caloriesRecette: UILabel!
    @IBOutlet weak var titleRecette: UILabel!
    @IBOutlet weak var imageRecette: UIImageView!
    @IBOutlet weak var yieldRecette: UILabel!
    @IBOutlet weak var timeRecette: UILabel!
    @IBOutlet weak var viewIndication: UIView! {
        didSet {
            viewIndication.layer.cornerRadius = 5
            viewIndication.layer.borderWidth = 2.5
            viewIndication.layer.borderColor = UIColor.white.cgColor
            viewIndication.layer.masksToBounds = true
        }
    }
    
    func setDetailRecette(data: Hits, image: UIImage) {
        self.yieldRecette.text = String(data.recipe.yield)
        self.timeRecette.text = String(data.recipe.totalTime) + "m"
        self.imageRecette.image = image
        self.titleRecette.text = data.recipe.label
        self.caloriesRecette.text = String(Int(data.recipe.calories)) + " calories"
    }

}
