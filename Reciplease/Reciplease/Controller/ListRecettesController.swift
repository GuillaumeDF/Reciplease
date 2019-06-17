//
//  ListRecettesController.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 11/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class ListRecettesController: UIViewController {

    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var listRecette: Recettes!
    var recettePicked: Hits!
    var imagePicked: UIImage!
    
    @IBOutlet weak var recettesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.setResetButton()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFavoriesListRecettes), name: .reloadFavoriesListRecettes, object: nil)
        if isFavorie {
            self.listRecette = AppDelegate.delegate.favorie
        }
    }
    
    @objc func reloadFavoriesListRecettes() {
        if isFavorie {
            self.listRecette = AppDelegate.delegate.favorie
            tableView.reloadData()
        }
    }
    
    @IBAction func resetFavorie(_ sender: Any) {
        Favorie.resetFavorie()
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard isFavorie else {
            return
        }
        if editingStyle == .delete {
            Favorie.deleteElement(row: indexPath.row)
        }
    }
}

extension ListRecettesController {
    
    func setResetButton() {
        if isFavorie {
            self.resetButton.isEnabled = true
        }
        else {
            self.resetButton.isEnabled = false
        }
    }
}
