//
//  BookStore_ThiagoSantiagoTests.swift
//  BookStore_ThiagoSantiagoTests
//
//  Created by Thiago Santiago on 29/05/21.
//

import XCTest
@testable import BookStore_ThiagoSantiago

final class BooksListPresenterMock: BooksListPresenting {
    var viewController: BookListDisplaying?
    
    private(set) var didPresentError = 0
    private(set) var didPresentLoading = 0
    private(set) var didHideLoading = 0
    private(set) var didPresentBookDetails = 0
    private(set) var didShowBookList = 0
    private(set) var didPresentFavoriteBooks = 0
    private(set) var messageError: String?
    private(set) var bookDto: BooksDto?
    private(set) var booksList: [BooksDto]?
    private(set) var favoriteBooksList: [BooksDto]?
    
    func presentError(message: String) {
        didPresentError += 1
        messageError = message
    }
    
    func showLoadingView() {
        didPresentLoading += 1
    }
    
    func hideLoadingView() {
        didHideLoading += 1
    }
    
    func presentBookDetails(book: BooksDto) {
        didPresentBookDetails += 1
        bookDto = book
    }
    
    func showBooksList(books: [BooksDto]) {
        didShowBookList += 1
        booksList = books
    }
    
    func presentFavoriteBooks(books: [BooksDto]) {
        didPresentFavoriteBooks += 1
        favoriteBooksList = books
    }
}

final class BooksListWorkerMock: BooksListWorking {
    var shouldFail = false
    
    var bookList = BooksList(totalItems: 3, items: [Book(id: "1", selfLink: "", volumeInfo: BookInfo(title: "Delphi para Android e iOS", subtitle: "Desenvolvendo aplicativos móveis", authors: ["William Duarte"], publisher: "Brasport", publishedDate: "2015-09-01", volumeInfoDescription: "Inovar, empreender, criar e sonhar! Em um mundo cada vez mais conectado, inovar é sinônimo de criatividade e inteligência. Eletrônicos como celulares e dispositivos “vestíveis” já fazem parte do nosso dia a dia. Pensando nisso, nada melhor que colocar aquela sua ideia em prática: empreender criando aplicativos de sucesso. Com este livro será possível aprender como desenvolver aplicativos para dispositivos móveis, sejam celulares, tablets, relógios, óculos, etc. Inclui tópicos sobre Firemonkey, layouts responsivos, sensores, bancos de dados embarcado SQLite, câmera fotográfica, geolocalização (GPS), monetização, notificações e muito mais. Utilizando o Delphi, seus aplicativos serão desenvolvidos de forma amigável, simples e rápida. Ganhe dinheiro juntando criatividade, inovação e DELPHI! Prefácios de Marco Cantù e Claudio Nasajon", pageCount: 216, printType: "BOOK", maturityRating: "NOT_MATURE", imageLinks: BookImageLinks(smallThumbnail: "", thumbnail: ""), language: "un", previewLink: "", infoLink: "", categories: ["Computers"], averageRating: nil, ratingCount: nil), saleInfo: BookSaleInfo(country: "BR", saleability: "FOR_SALE", isEbook: true, listPrice: nil, retailPrice: nil, buyLink: nil))])
    
    func getBooksList(pageIndex: Int, success: @escaping (BooksList) -> Void, failure: @escaping (BookStoreApiError) -> Void) {
        if shouldFail {
            failure(.badRequest)
        } else {
            success(bookList)
        }
    }
}

final class BooksListInteractorTests: XCTestCase {
    let presenterMock = BooksListPresenterMock()
    let workerMock = BooksListWorkerMock()
    
    private lazy var sut: BooksListInteractor = {
        let interactor = BooksListInteractor(presenter: presenterMock, worker: workerMock)
        return interactor
    }()
    
    func testLoadData() {
        sut.loadData()
        
        guard let book = presenterMock.booksList?.first else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(presenterMock.didPresentLoading, 1)
        XCTAssertEqual(presenterMock.didHideLoading, 1)
        XCTAssertEqual(presenterMock.didShowBookList, 1)
        XCTAssertNotNil(presenterMock.booksList)
        XCTAssertEqual(book.title, workerMock.bookList.items.first?.volumeInfo.title)
        XCTAssertEqual(book.subtitle, workerMock.bookList.items.first?.volumeInfo.subtitle)
    }
    
    func testListAllBooks(){
        sut.loadData()
        sut.listAllBooks()
        
        guard let book = presenterMock.booksList?.first else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(presenterMock.didShowBookList, 2)
        XCTAssertNotNil(presenterMock.booksList)
        XCTAssertEqual(book.title, workerMock.bookList.items.first?.volumeInfo.title)
        XCTAssertEqual(book.subtitle, workerMock.bookList.items.first?.volumeInfo.subtitle)
    }
    
    func testGetNextPage() {
        sut.getNextPage()
        
        guard let book = presenterMock.booksList?.first else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(presenterMock.didPresentLoading, 1)
        XCTAssertEqual(presenterMock.didHideLoading, 1)
        XCTAssertEqual(presenterMock.didShowBookList, 1)
        XCTAssertNotNil(presenterMock.booksList)
        XCTAssertEqual(book.title, workerMock.bookList.items.first?.volumeInfo.title)
        XCTAssertEqual(book.subtitle, workerMock.bookList.items.first?.volumeInfo.subtitle)
    }
    
    func testListAllFavoriteBooks() {
        sut.listAllFavoriteBooks()
        
        XCTAssertEqual(presenterMock.didPresentFavoriteBooks, 1)
        XCTAssertNotNil(presenterMock.favoriteBooksList)
        XCTAssertEqual(presenterMock.favoriteBooksList?.count, 0)
        
    }
    
    func testPresentError() {
        workerMock.shouldFail = true
        
        sut.loadData()
        
        XCTAssertEqual(presenterMock.didPresentLoading, 1)
        XCTAssertEqual(presenterMock.didHideLoading, 1)
        XCTAssertEqual(presenterMock.didPresentError, 1)
        XCTAssertNil(presenterMock.booksList)
        XCTAssertEqual(presenterMock.messageError, "This is a bad request.")
    }
    
    func testSetBookAsFavorite() {
        sut.setBookAsFavorite(bookId: "1")
        
    }
    
    func testRemoveFromFavorite() {
        sut.removeFromFavorite(bookId: "1")
    }
    
    func testMoveToBookDetail() {
        let book = BooksDto(bookId: "1", title: "Delphi para Android e iOS", subtitle: "Desenvolvendo aplicativos móveis", imageUrl: "", isFavorite: true)
        sut.moveToBookDetail(book: book)
        
        XCTAssertEqual(presenterMock.didPresentBookDetails, 1)
        XCTAssertNotNil(presenterMock.bookDto)
        XCTAssertEqual(presenterMock.bookDto?.title, book.title)
        XCTAssertEqual(presenterMock.bookDto?.bookId, book.bookId)
        XCTAssertEqual(presenterMock.bookDto?.subtitle, book.subtitle)
        XCTAssertEqual(presenterMock.bookDto?.imageUrl, book.imageUrl)
        XCTAssertEqual(presenterMock.bookDto?.isFavorite, book.isFavorite)
    }
}
