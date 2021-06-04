//
//  BooksListPresenterTests.swift
//  BookStore_ThiagoSantiagoTests
//
//  Created by Thiago Santiago on 04/06/21.
//

import XCTest
@testable import BookStore_ThiagoSantiago


final class ViewControllerMock: BookListDisplaying {
    private(set) var didShowLoaderView = 0
    private(set) var didHideLoaderView = 0
    private(set) var didShowError = 0
    private(set) var didShowBooks = 0
    private(set) var errorMessage: String?
    private(set) var booksList: [BooksDto]?
    
    
    func showLoaderView() {
        didShowLoaderView += 1
    }
    
    func hideLoaderView() {
        didHideLoaderView += 1
    }
    
    func showError(message: String) {
        didShowError += 1
        errorMessage = message
    }
    
    func showBooksContent(booksList: [BooksDto]) {
        didShowBooks += 1
        self.booksList = booksList
    }
}

final class BooksListPresenterTests: XCTestCase {
    
    private let viewControllerMock = ViewControllerMock()
    private lazy var sut: BooksListPresenting = {
        let presenter = BooksListPresenter()
        presenter.viewController = viewControllerMock
        return presenter
    }()
    private let book = BooksDto(bookId: "1",
                        title: "Delphi para Android e iOS",
                        subtitle: "Desenvolvendo aplicativos móveis",
                        imageUrl: "",
                        isFavorite: true)

    func testShowLoadingView() {
        sut.showLoadingView()
        
        XCTAssertEqual(viewControllerMock.didShowLoaderView, 1)
    }
    
    func testHideLoadingView() {
        sut.hideLoadingView()
        
        XCTAssertEqual(viewControllerMock.didHideLoaderView, 1)
    }
    
    func testPresentError() {
        sut.presentError(message: "Can't convert the data to the object entity.")
        
        XCTAssertEqual(viewControllerMock.didShowError, 1)
        XCTAssertEqual(viewControllerMock.errorMessage, "Can't convert the data to the object entity.")
    }
    
    func testShowBooksList() {
        sut.showBooksList(books: [book])
        
        XCTAssertEqual(viewControllerMock.didShowBooks, 1)
        XCTAssertNotNil(viewControllerMock.booksList)
        XCTAssertEqual(viewControllerMock.booksList?.count, 1)
        XCTAssertEqual(viewControllerMock.booksList?.first?.bookId, book.bookId)
        XCTAssertEqual(viewControllerMock.booksList?.first?.title, book.title)
        XCTAssertEqual(viewControllerMock.booksList?.first?.subtitle, book.subtitle)
        XCTAssertEqual(viewControllerMock.booksList?.first?.imageUrl, book.imageUrl)
        XCTAssertEqual(viewControllerMock.booksList?.first?.isFavorite, book.isFavorite)
    }
    
    func test() {
        sut.presentFavoriteBooks(books: [book])
        
        XCTAssertEqual(viewControllerMock.didShowBooks, 1)
        XCTAssertNotNil(viewControllerMock.booksList)
        XCTAssertEqual(viewControllerMock.booksList?.count, 1)
        XCTAssertEqual(viewControllerMock.booksList?.first?.bookId, book.bookId)
        XCTAssertEqual(viewControllerMock.booksList?.first?.title, book.title)
        XCTAssertEqual(viewControllerMock.booksList?.first?.subtitle, book.subtitle)
        XCTAssertEqual(viewControllerMock.booksList?.first?.imageUrl, book.imageUrl)
        XCTAssertEqual(viewControllerMock.booksList?.first?.isFavorite, book.isFavorite)
    }
}
