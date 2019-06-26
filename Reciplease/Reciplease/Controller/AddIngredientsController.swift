//
//  AddIngredientsController.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 11/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit
import Alamofire

class AddIngredientsController: UIViewController {

    let ingredients = AddIngredient()
    @IBOutlet weak var ingredientText: UISearchBar!
    @IBOutlet weak var ingredientTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar() // Set color and fond text
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayError), name: .error, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataReceived), name: .dataRecette, object: nil)
    }
    
    @objc func dataReceived() { // Go into next controller when notification data is received
        performSegue(withIdentifier: "segueToListRecettes", sender: self)
    }
    
    @IBAction func addIngredient(_ sender: Any) { // Add new ingredient and reload the tableView
        self.ingredients.addIngredient(ingredient: ingredientText.text ?? "nil")
        self.ingredientTableView.reloadData()
    }
    
    @IBAction func clearIngredients(_ sender: Any) { // Clear all ingredients and reload tableView
        self.ingredients.clearIngredients()
        self.ingredientTableView.reloadData()
    }
    
    @IBAction func searchForRecipes(_ sender: Any) { // Call a function to create a request and get data
        self.ingredients.sendRequest()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Prepare variables for the changement of controller
        if segue.identifier == "segueToListRecettes" {
            let successVC = segue.destination as! ListRecettesController
            guard let tmpListRecette = ingredients.dataRecette else {
                return successVC.listRecette = Recettes(recettes: CurrentRecettes(hits: []), images: [])
            }
            successVC.listRecette = tmpListRecette
        }
    }
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        ingredientText.resignFirstResponder()
    }
}

extension AddIngredientsController: UITableViewDataSource, UITableViewDelegate {
    
    // Return the number of cell in TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.arrayIngredients.count
    }
    
    // Return cell with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: IngredientsViewCell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell") as! IngredientsViewCell
        let data = ingredients.arrayIngredients[indexPath.row]
        
       cell.newIngredient = data
        return cell
    }
    
    // Delete cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredients.removeIngredient(index: indexPath.row)
            ingredientTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Return height of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
