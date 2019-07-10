//
//  RecipeController.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 12/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class RecipeController: UIViewController {

    var imageRecette: Data!
    var dataRecette: Hits!
    var favoriteOrNot = FavoriteOrNot()
    var favoriteSelected: Bool!
    var rowElement: Int!
    @IBOutlet var detailRecipeView: RecipeDetailsView!
    @IBOutlet weak var saveRecette: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favoriteOrNot = FavoriteOrNot(title: navigationController?.title ?? "")
        self.setButtonFavorite()
        self.detailRecipeView.setDetailRecette(data: dataRecette, image: imageRecette) // Set the detail of the recette
    }
    
    @IBAction func saveRecette(_ sender: Any) {
        if self.favoriteSelected {
            self.saveElement()
        }
        else if self.favoriteOrNot.isFavorite && !self.favoriteSelected {
            self.deleteElement()
        }
    }
    
    private func saveElement() {
        let favorie = Favorite(context: AppDelegate.viewContext) // Creata a new context of Favorie
        favorie.addElement(dataRecette: dataRecette, imageRecette: imageRecette) // Add a new element to Favore
        self.saveRecette.image = UIImage(named: "favorieUnselected")
        self.favoriteSelected = false
    }
    
    private func deleteElement() {
        Favorite.deleteElement(row: self.rowElement)
        self.saveRecette.image = UIImage(named: "favorieSelected")
        self.favoriteSelected = true
    }
}

extension RecipeController: UITableViewDataSource, UITableViewDelegate {
    
    // Return the number of cell in TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataRecette.recipe.ingredientLines.count
    }
    
    // Return cell with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: IngredientsViewCell = tableView.dequeueReusableCell(withIdentifier: "displayIngredientCell") as? IngredientsViewCell else {
            return UITableViewCell()
        }
        let data = self.dataRecette.recipe.ingredientLines[indexPath.row]
        cell.displayIngredient = data
        return cell
    }
    
    // Return height of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension RecipeController {
    
    private func setButtonFavorite() {
        if self.favoriteOrNot.isFavorite {
            self.saveRecette.image = UIImage(named: "favorieUnselected")
            self.favoriteSelected = false
        }
        else {
            self.saveRecette.image = UIImage(named: "favorieSelected")
            self.favoriteSelected = true
        }
    }
}
