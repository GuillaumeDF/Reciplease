//
//  ListRecettesController.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 11/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class ListRecettesController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var listRecette: Recettes!
    var recettePicked: Hits!
    var imagePicked: UIImage!
    var typeNavigation: String? {
        return navigationController?.title
    }
    
    @IBOutlet weak var recettesTableView: UITableView!
    
    /*override func viewDidAppear(_ animated: Bool) {
        if (typeNavigation == "Favorie") {
            self.listRecette = AppDelegate.delegate.favorie
            tableView.reloadData()
        }
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFavoriesListRecettes), name: .reloadFavoriesListRecettes, object: nil)
        guard (typeNavigation != nil) else {
            return NotificationCenter.default.post(name: .error, object: ["Error Url", "Can't construct URL"])
        }
        if (typeNavigation == "Favorie") {
            self.listRecette = AppDelegate.delegate.favorie
        }
    }
    
    @objc func reloadFavoriesListRecettes() {
        if (typeNavigation == "Favorie") {
            self.listRecette = AppDelegate.delegate.favorie
            tableView.reloadData()
        }
    }
    
    @IBAction func resetFavorie(_ sender: Any) {
        let favorie = Favorie(context: AppDelegate.viewContext)
        favorie.resetFavorie()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToRecette" {
            let successVC = segue.destination as! RecetteController
            successVC.dataRecette = self.recettePicked
            successVC.imageRecette = self.imagePicked
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.recettePicked = listRecette.recettes.hits[indexPath.row]
        self.imagePicked = listRecette.images[indexPath.row]
        performSegue(withIdentifier: "segueToRecette", sender: self)
    }
}
