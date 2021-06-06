//
//  BooksListPresenter.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 03/06/21.
//

import Foundation

protocol BooksListPresenting: AnyObject {
    var viewController: BookListDisplaying? { get set }
    func presentError(message: String)
    func showLoadingView()
    func hideLoadingView()
    func presentBookDetails(book: BooksDto)
    func showBooksList(books: [BooksDto])
    func presentFavoriteBooks(books: [BooksDto])
}

final class BooksListPresenter: BooksListPresenting {
    weak var viewController: BookListDisplaying?
    
    func presentError(message: String) {
        viewController?.showError(message: message)
    }
    
    func showLoadingView() {
        viewController?.showLoaderView()
    }
    
    func hideLoadingView() {
        viewController?.hideLoaderView()
    }
    
    func showBooksList(books: [BooksDto]) {
        viewController?.showBooksContent(booksList: books)
    }
    
    func presentFavoriteBooks(books: [BooksDto]) {
        viewController?.showBooksContent(booksList: books)
    }
    
    func presentBookDetails(book: BooksDto) {
        AppRouter.shared.routeToBookDetails(book: book)
    }
}
