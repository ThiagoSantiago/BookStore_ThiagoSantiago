//
//  AppRouter.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 02/06/21.
//

import UIKit

class AppRouter {
    
    static let shared = AppRouter()
    
    var navigation: UINavigationController = UINavigationController()
    
    func routeToBooksList() {
        let viewController = BooksListFactory.make()
        self.navigation.pushViewController(viewController, animated: false)
    }
}
