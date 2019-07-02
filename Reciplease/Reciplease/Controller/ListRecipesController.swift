//
//  ListRecipesController.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 11/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class ListRecipesController: UIViewController {

    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var listRecipe: Recipes!
    // Variable send  to RecetteController for show in detail the recette
    var recipePicked: Hits!
    var imagePicked: UIImage!
    
    @IBOutlet weak var recettesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar() // Set color and fond text
        self.setResetButton() // Set reset Button hidden / not hidden
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFavoritesListRecipes), name: .reloadFavoritesListRecipes, object: nil)
        if isFavorie {
            self.listRecipe = AppDelegate.delegate.favorite  // If controller is Favorie then recette = ReccetteFavorie
        }
    }
    
    @objc func reloadFavoritesListRecipes() { // Reload listFavorieRecette
        if isFavorie { // If controller is Favorie then recette = ReccetteFavorie
            self.listRecipe = AppDelegate.delegate.favorite
            tableView.reloadData()
        }
    }
    
    @IBAction func resetFavorie(_ sender: Any) { // Reset all favorie
        Favorite.resetFavorite()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Prepare variables for the changement of controller
        if segue.identifier == "segueToRecipe" {
            let successVC = segue.destination as! RecipeController
            successVC.dataRecette = self.recipePicked
            successVC.imageRecette = self.imagePicked
        }
    }
}

extension ListRecipesController: UITableViewDataSource, UITableViewDelegate {
    
    // Return the number of cell in TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRecipe.recipes.hits.count
    }
    
    // Return cell with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecipeViewCell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as! RecipeViewCell
        let data = listRecipe.recipes.hits[indexPath.row]
        let image = listRecipe.images[indexPath.row]
        cell.setRecipeCell(recipe: data, image: image)
        return cell
    }
    
    // Return height of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // Get index of cell selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.recipePicked = listRecipe.recipes.hits[indexPath.row]
        self.imagePicked = listRecipe.images[indexPath.row]
        performSegue(withIdentifier: "segueToRecipe", sender: self)
    }
    
    // Delete cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard isFavorie else {
            return
        }
        if editingStyle == .delete {
            Favorite.deleteElement(row: indexPath.row)
        }
    }
}

extension ListRecipesController {
    
    func setResetButton() { // Set the button reset
        if isFavorie {
            self.resetButton.isEnabled = true
        }
        else {
            self.resetButton.isEnabled = false
        }
    }
}
