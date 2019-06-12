//
//  RecetteController.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 12/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class RecetteController: UIViewController {

    var imageRecette: UIImage!
    var dataRecette: Hits!
    
    @IBOutlet weak var imageView: imageRecette!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.setImageRecette(image: imageRecette)
        // Do any additional setup after loading the view.
    }
}

extension RecetteController: UITableViewDataSource, UITableViewDelegate {
    
    // Return the number of column in TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataRecette.recipe.ingredientLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: IngredientsViewCell = tableView.dequeueReusableCell(withIdentifier: "displayIngredientCell") as! IngredientsViewCell
        let data = self.dataRecette.recipe.ingredientLines[indexPath.row]
        cell.displayIngredient = data
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
