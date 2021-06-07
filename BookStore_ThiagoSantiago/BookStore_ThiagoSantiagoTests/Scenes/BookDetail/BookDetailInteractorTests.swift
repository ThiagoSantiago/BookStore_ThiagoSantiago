//
//  BookDetailInteractorTests.swift
//  BookStore_ThiagoSantiagoTests
//
//  Created by Thiago Santiago on 06/06/21.
//

import XCTest
@testable import BookStore_ThiagoSantiago

final class BookDetailPresenterMock: BookDetailPresenting {
    var viewController: BookDetailDisplaying?
    private(set) var didPresentBookContent = 0
    private(set) var didPresentBuyLink = 0
    private(set) var book: BooksDto?
    private(set) var buyLink: String?
    
    func presentBookContent(book: BooksDto) {
        didPresentBookContent += 1
        self.book = book
    }
    
    func presentBuyLink(buylink: String) {
        didPresentBuyLink += 1
        self.buyLink = buylink
    }
}

final class BookDetailInteractorTests: XCTestCase {
    private let presenterMock = BookDetailPresenterMock()
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
    
    private lazy var sut: BookDetailInteracting = {
       let interactor = BookDetailInteractor(presenter: presenterMock, book: book)
        return interactor
    }()

    func testSetBookContent() {
        sut.setBookContent()
        
        XCTAssertEqual(presenterMock.didPresentBookContent, 1)
        XCTAssertNotNil(presenterMock.book)
        XCTAssertEqual(presenterMock.book?.title, book.title)
        XCTAssertEqual(presenterMock.book?.numberOfPages, book.numberOfPages)
        XCTAssertEqual(presenterMock.book?.buyLink, book.buyLink)
    }
    
    func test() {
        sut.buyButtonTapped()
        
        XCTAssertEqual(presenterMock.didPresentBuyLink, 1)
        XCTAssertNotNil(presenterMock.buyLink)
        XCTAssertEqual(presenterMock.buyLink, book.buyLink)
    }
}
