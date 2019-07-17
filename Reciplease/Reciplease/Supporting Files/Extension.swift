//
//  Extension.swift
//  Reciplease
//
//  Created by Guillaume Djaider Fornari on 11/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    
    static let error = Notification.Name("error")
    static let reloadFavoritesListRecipes = Notification.Name("reloadFavoritesListRecipes")
    static let notFavotite = Notification.Name("notFavotite")
    static let isFavoriteAndFavorites = Notification.Name("isFavoriteAndFavorites")
    static let isFavoriteAndNoFavorite = Notification.Name("isFavoriteAndNoFavorite")
}

extension UIViewController {
    
    func displayAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc func displayError(notification :Notification) {
        guard let dataError = notification.object as? [String] else {
            return
        }
        self.displayAlert(title: dataError[0], message: dataError[1])
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 20)!]
        self.navigationController?.navigationBar.barTintColor =  .recipleaseColor
    }
}

extension UIColor {
    
    static let recipleaseColor: UIColor = UIColor(red: 54/255.0, green: 51/255.0, blue: 50/255.0, alpha: 1.0)
}
