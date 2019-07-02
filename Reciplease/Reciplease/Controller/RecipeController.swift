//
//  RecipeController.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 12/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class RecipeController: UIViewController {

    var imageRecette: UIImage!
    var dataRecette: Hits!
    @IBOutlet var detailRecipeView: RecipeDetailsView!
    //@IBOutlet var detailRecetteView: RecipeDetailsView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAddButton()
        self.detailRecipeView.setDetailRecette(data: dataRecette, image: imageRecette) // Set the detail of the recette
    }
    
    @IBAction func saveRecette(_ sender: Any) { // Save recette
        let favorie = Favorite(context: AppDelegate.viewContext) // Creata a new context of Favorie
        favorie.addElement(dataRecette: dataRecette, imageRecette: imageRecette.pngData()) // Add a new element to Favore
    }
}

extension RecipeController: UITableViewDataSource, UITableViewDelegate {
    
    // Return the number of cell in TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataRecette.recipe.ingredientLines.count
    }
    
    // Return cell with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: IngredientsViewCell = tableView.dequeueReusableCell(withIdentifier: "displayIngredientCell") as! IngredientsViewCell
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
    
    func setAddButton() {
        if isFavorie { // Check if navigationController.title == Favorie
            self.addButton.isEnabled = false
        }
        else {
            self.addButton.isEnabled = true
        }
    }
}
