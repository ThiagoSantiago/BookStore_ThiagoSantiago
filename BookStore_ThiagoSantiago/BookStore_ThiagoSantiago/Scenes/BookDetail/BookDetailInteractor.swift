//
//  BookDetailInteractor.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 05/06/21.
//

import Foundation

protocol BookDetailInteracting: AnyObject {
    var shouldHideCart: Bool { get }
    func setBookContent()
    func buyButtonTapped()
    func setBookAsFavorite()
    func removeBookFromFavorites()
}

final class BookDetailInteractor: BookDetailInteracting {
    private let presenter: BookDetailPresenting
    private let book: BooksDto
    private let defaultWorker: UserDefaultsWorking
    
    var shouldHideCart: Bool
    
    init(presenter: BookDetailPresenting, book: BooksDto, defaultWorker: UserDefaultsWorking = UserDefaultsWorker()) {
        self.book = book
        self.presenter = presenter
        self.defaultWorker = defaultWorker
        shouldHideCart = book.buyLink?.isEmpty ?? true
    }
    
    func buyButtonTapped() {
        presenter.presentBuyLink(buylink: book.buyLink ?? "")
    }
    
    func setBookContent() {
        presenter.presentBookContent(book: book)
    }
    
    func setBookAsFavorite() {
        defaultWorker.saveItem(itemId: book.bookId)
    }
    
    func removeBookFromFavorites() {
        defaultWorker.removeItem(itemId: book.bookId)
    }
}
