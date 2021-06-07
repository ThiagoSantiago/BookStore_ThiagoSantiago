//
//  BookDetailPresenterTests.swift
//  BookStore_ThiagoSantiagoTests
//
//  Created by Thiago Santiago on 06/06/21.
//

import XCTest
@testable import BookStore_ThiagoSantiago

final class BookDetailViewControllerMock: BookDetailDisplaying {
    private(set) var didShowBookContent = 0
    private(set) var book: BooksDto?
    
    func showBookContent(book: BooksDto) {
        didShowBookContent += 1
        self.book = book
    }
}

final class BookDetailPresenterTests: XCTestCase {
    let viewControllerMock = BookDetailViewControllerMock()
    private let book = BooksDto(bookId: "1",
                                title: "Delphi para Android e iOS",
                                subtitle: "Desenvolvendo aplicativos móveis",
                                imageUrl: "",
                                isFavorite: true,
                                description: "",
                                authors: nil,
                                numberOfPages: 44,
                                publisher: nil,
                                buyLink: "http://www.itsector.pt/")
    private(set) lazy var sut: BookDetailPresenting = {
        let presenter =  BookDetailPresenter()
        presenter.viewController = viewControllerMock
        return presenter
    }()

    
    func test() {
        sut.presentBookContent(book: book)
        
        XCTAssertEqual(viewControllerMock.didShowBookContent, 1)
        XCTAssertNotNil(viewControllerMock.book)
        XCTAssertEqual(viewControllerMock.book?.title, book.title)
        XCTAssertEqual(viewControllerMock.book?.subtitle, book.subtitle)
        XCTAssertEqual(viewControllerMock.book?.numberOfPages, book.numberOfPages)
        XCTAssertEqual(viewControllerMock.book?.buyLink, book.buyLink)
    }
}
