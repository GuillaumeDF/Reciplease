//
//  NoFavoriteView.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 05/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class NoFavoriteView: UILabel {
    
    func setLabelFavorite() {
            self.isHidden = false
            self.text = "It seems you don't have a favorite recipe yet. Don't panic, you can add one with the button at the top right of the recipe !"
    }
    
    func hiddenLabelNoFavorite() {
        self.isHidden = true
    }

}
