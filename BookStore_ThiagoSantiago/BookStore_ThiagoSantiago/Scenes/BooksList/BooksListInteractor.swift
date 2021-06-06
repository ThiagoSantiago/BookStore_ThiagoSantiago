//
//  BookssListInteractor.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 03/06/21.
//

import Foundation

protocol BooksListInteracting: AnyObject {
    var isSearching: Bool { get }
    var showingFavorites: Bool { get }
    func loadData()
    func resetPages()
    func getNextPage()
    func listAllBooks()
    func stopSearching()
    func listAllFavoriteBooks()
    func searchBook(text: String)
    func moveToBookDetail(book: BooksDto)
    func setBookAsFavorite(bookId: String)
    func removeFromFavorite(bookId: String)
}

final class BooksListInteractor: BooksListInteracting {
    private let presenter: BooksListPresenting
    private let worker: BooksListWorking
    private let defaultsWorker: UserDefaultsWorking
    private var currentPage = 0
    private var booksList: [BooksDto] = []
    var isSearching: Bool = false
    var showingFavorites: Bool = false
    
    init(presenter: BooksListPresenting, worker: BooksListWorking = BooksListWorker(), defaultsWorker: UserDefaultsWorking = UserDefaultsWorker()) {
        self.presenter = presenter
        self.worker = worker
        self.defaultsWorker = defaultsWorker
    }
    
    
    func loadData() {
        presenter.showLoadingView()
        worker.getBooksList (pageIndex: currentPage, success: { [weak self] books in
            guard let self = self else { return }
            self.presenter.hideLoadingView()
            
            let booksDtoList = books.items.map { BooksDto(bookId: $0.id,
                                                          title: $0.volumeInfo.title,
                                                          subtitle: $0.volumeInfo.subtitle,
                                                          imageUrl: $0.volumeInfo.imageLinks.thumbnail,
                                                          isFavorite: self.verifyIfIsFavorite(bookId: $0.id),
                                                          description: $0.volumeInfo.description ?? "",
                                                          authors: $0.volumeInfo.authors,
                                                          numberOfPages: $0.volumeInfo.pageCount,
                                                          publisher: $0.volumeInfo.publisher,
                                                          buyLink: $0.saleInfo.buyLink)
            }
            
            self.booksList.append(contentsOf: booksDtoList)
            self.booksList = self.booksList.uniqued()
            self.presenter.showBooksList(books: self.booksList)
        }, failure: { [weak self] error in
            self?.presenter.hideLoadingView()
            self?.presenter.presentError(message: error.localizedDescription)
        })
    }
    
    func listAllBooks() {
        showingFavorites = false
        presenter.showBooksList(books: booksList)
    }
    
    func listAllFavoriteBooks() {
        showingFavorites = true
        let favoriteBooksIds = defaultsWorker.getItemsSaved()
        var favoriteBooks: [BooksDto] = []
        
        favoriteBooksIds.forEach { bookId in
            let books = booksList.filter { $0.bookId == bookId }
            favoriteBooks.append(contentsOf: books)
        }
        
        presenter.presentFavoriteBooks(books: favoriteBooks)
    }
    
    private func verifyIfIsFavorite(bookId: String) -> Bool {
        let favoriteBooks = defaultsWorker.getItemsSaved()
        
        return favoriteBooks.contains(bookId)
    }
    
    func setBookAsFavorite(bookId: String) {
        var favoriteBook = booksList.first { $0.bookId == bookId }
        favoriteBook?.isFavorite = true
        defaultsWorker.saveItem(itemId: bookId)
    }
    
    func removeFromFavorite(bookId: String) {
        var favoriteBook = booksList.first { $0.bookId == bookId }
        favoriteBook?.isFavorite = false
        defaultsWorker.removeItem(itemId: bookId)
    }
    
    func searchBook(text: String) {
        isSearching = true
        
        if text.isEmpty {
            presenter.showBooksList(books: booksList)
        } else {
            let filteredBooks = booksList.filter { $0.title.uppercased().contains(text.uppercased()) }
            presenter.showBooksList(books: filteredBooks)
        }
    }
    
    func stopSearching() {
        isSearching = false
        presenter.showBooksList(books: booksList)
    }
    
    func moveToBookDetail(book: BooksDto) {
        presenter.presentBookDetails(book: book)
    }
    
    func getNextPage() {
        currentPage += 1
        loadData()
    }
    
    func resetPages() {
        currentPage = 0
    }
}
