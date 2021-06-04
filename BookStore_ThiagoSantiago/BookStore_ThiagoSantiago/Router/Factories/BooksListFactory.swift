//
//  BooksListFactory.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 02/06/21.
//

import Foundation

final class BooksListFactory {
    static func make() -> BooksListViewController {
        let presenter = BooksListPresenter()
        let interactor = BooksListInteractor(presenter: presenter)
        let viewController = BooksListViewController(interactor: interactor)
        presenter.viewController = viewController
        
        return viewController
    }
}
