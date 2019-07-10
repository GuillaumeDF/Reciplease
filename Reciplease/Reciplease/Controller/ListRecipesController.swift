//
//  ListRecipesController.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 11/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit
import Foundation

class ListRecipesController: UIViewController {

    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noFavorite: NoFavoriteView!
    
    var listRecipe: Recipes?
    // Variable send  to RecetteController for show in detail the recette
    var recipePicked: Hits!
    var imagePicked: Data!
    var rowElement: Int!
    @IBOutlet weak var recettesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar() // Set color and fond text
        self.setController()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFavoritesListRecipes), name: .reloadFavoritesListRecipes, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setController()
    }
    
    func setController() {
        FavoriteOrNot(title: navigationController?.title ?? "").setFavoriteOrNot() { (callback) in
            switch callback {
            case "isNotFavorite" :
                self.notFavorite()
            case "isFavoriteAndFavorites" :
                self.isFavoriteAndFavorites()
            case "isFavoriteAndNoFavorite" :
                self.isFavoriteAndNoFavorite()
            default:
                return
            }
        }
    }
    
    @objc func reloadFavoritesListRecipes() { // Reload listFavorieRecette
        if FavoriteOrNot(title: navigationController?.title ?? "").isFavorite { // If controller is Favorie then recette = ReccetteFavorie
            self.listRecipe = AppDelegate.delegate.favorite
            tableView.reloadData()
        }
    }
    
    private func isFavoriteAndNoFavorite() {
        self.tableView.isHidden = true
        self.noFavorite.setLabelFavorite()
        self.listRecipe = AppDelegate.delegate.favorite
        self.tableView.reloadData()
    }
    
    private func isFavoriteAndFavorites() {
        self.tableView.isHidden = false
        self.noFavorite.hiddenLabelNoFavorite()
        self.listRecipe = AppDelegate.delegate.favorite  // If controller is Favorie then recette = ReccetteFavorie
        self.tableView.reloadData()
    }
    
    private func notFavorite() {
        self.noFavorite.hiddenLabelNoFavorite()
        self.tableView.isHidden = false
    }
    
    @IBAction func resetFavorie(_ sender: Any) { // Reset all favorie
        Favorite.resetFavorite()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Prepare variables for the changement of controller
        if segue.identifier == "segueToRecipe" {
            let successVC = segue.destination as? RecipeController
            successVC?.dataRecette = self.recipePicked
            successVC?.imageRecette = self.imagePicked
            successVC?.rowElement = self.rowElement
        }
    }
}

extension ListRecipesController: UITableViewDataSource, UITableViewDelegate {
    
    // Return the number of cell in TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRecipe?.recipes.hits.count ?? 0
    }
    
    // Return cell with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: RecipeViewCell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as? RecipeViewCell,
        let data = listRecipe?.recipes.hits[indexPath.row],
        let image = listRecipe?.images[indexPath.row] else {
            return UITableViewCell()
        }
        cell.setRecipeCell(recipe: data, image: image)
        return cell
    }
    
    // Return height of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // Get index of cell selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.recipePicked = listRecipe?.recipes.hits[indexPath.row]
        self.imagePicked = listRecipe?.images[indexPath.row]
        self.rowElement = indexPath.row
        performSegue(withIdentifier: "segueToRecipe", sender: self)
    }
}
