//
//  ListRecettesController.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 11/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class ListRecettesController: UIViewController {

    var listRecette: Recettes!
    @IBOutlet weak var recettesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ListRecettesController: UITableViewDataSource, UITableViewDelegate {
    // Return the number of column in TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRecette.recettes.hits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecetteViewCell = tableView.dequeueReusableCell(withIdentifier: "RecetteCell") as! RecetteViewCell
        let data = listRecette.recettes.hits[indexPath.row]
        let image = listRecette.images[indexPath.row]
        cell.setRecetteCell(recette: data, image: image)
        cell.layer.cornerRadius = 5
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
