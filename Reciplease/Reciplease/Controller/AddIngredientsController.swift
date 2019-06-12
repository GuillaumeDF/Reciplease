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
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 20)!]
        self.navigationController?.navigationBar.barTintColor =  .recipleaseColor
        NotificationCenter.default.addObserver(self, selector: #selector(displayError), name: .error, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataReceived), name: .dataRecette, object: nil)
    }
    
    @objc func dataReceived() {
        performSegue(withIdentifier: "segueToListRecettes", sender: self)
    }
    
    @IBAction func addIngredient(_ sender: Any) {
        self.ingredients.addIngredient(ingredient: ingredientText.text ?? "nil")
        ingredientTableView.reloadData()
    }
    
    @IBAction func clearIngredients(_ sender: Any) {
        self.ingredients.clearIngredients()
        ingredientTableView.reloadData()
    }
    
    @IBAction func searchForRecipes(_ sender: Any) {
        ingredients.setParameters()
        ingredients.sendRequest()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToListRecettes" {
            let successVC = segue.destination as! ListRecettesController
            guard let tmpListRecette = ingredients.dataRecette else {
                return
            }
            successVC.listRecette = tmpListRecette
        }
    }
}

extension AddIngredientsController: UITableViewDataSource {
    
    // Return the number of column in TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.arrayIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: IngredientsViewCell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell") as! IngredientsViewCell
        let data = ingredients.arrayIngredients[indexPath.row]
        
       cell.newIngredient = data
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredients.removeIngredient(index: indexPath.row)
            ingredientTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
