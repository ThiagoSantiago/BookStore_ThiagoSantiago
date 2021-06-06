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
    
    func routeToBookDetails(book: BooksDto) {
        let viewController = BookDetailFactory.make(book: book)
        self.navigation.pushViewController(viewController, animated: false)
    }
    
    func openLink(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
