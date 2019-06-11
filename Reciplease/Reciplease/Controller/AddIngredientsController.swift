//
//  AddIngredientsController.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 11/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit
import Alamofire
// 5793f67a
// cae818758e2fe39a683ffd2bd89ff81a
// https://api.edamam.com/search?q=chicken&app_id=5793f67a&app_key=cae818758e2fe39a683ffd2bd89ff81a&q=meat

/*let parameters: Parameters = [
    "q": "Lemon",
    "app_id": "5793f67a",
    "app_key": "cae818758e2fe39a683ffd2bd89ff81a"
]*/

class AddIngredientsController: UIViewController {

    let ingredients = AddIngredient()
    @IBOutlet weak var ingredientText: UISearchBar!
    @IBOutlet weak var ingredientTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayError), name: .error, object: nil)
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
}

extension AddIngredientsController: UITableViewDataSource {
    
    // Return the number of column in TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.arrayIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: IngredientsViewCell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell") as! IngredientsViewCell
        let data = ingredients.arrayIngredients[indexPath.row]
        
       cell.displayIngredient = data
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredients.removeIngredient(index: indexPath.row)
            ingredientTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}
