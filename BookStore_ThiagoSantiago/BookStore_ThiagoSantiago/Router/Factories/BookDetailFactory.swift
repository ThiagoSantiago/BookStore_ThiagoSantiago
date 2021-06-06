//
//  BookDetailFactory.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 05/06/21.
//

import Foundation

final class BookDetailFactory {
    static func make(book: BooksDto) -> BookDetailViewController {
        let presenter = BookDetailPresenter()
        let interactor = BookDetailInteractor(presenter: presenter, book: book)
        let viewController = BookDetailViewController(interactor: interactor)
        presenter.viewController = viewController
        
        return viewController
    }
}

