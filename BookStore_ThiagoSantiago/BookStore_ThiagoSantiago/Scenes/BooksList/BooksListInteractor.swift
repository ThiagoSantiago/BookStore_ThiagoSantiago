//
//  BookssListInteractor.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 03/06/21.
//

import Foundation

protocol BooksListInteracting: AnyObject {
    var isSearching: Bool { get }
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
    private var currentPage = 0
    private var booksList: [BooksDto] = []
    var isSearching: Bool = false
       
    init(presenter: BooksListPresenting, worker: BooksListWorking = BooksListWorker()) {
           self.presenter = presenter
        self.worker = worker
       }
       
    
    func loadData() {
        presenter.showLoadingView()
        worker.getBooksList (pageIndex: currentPage, success: { [weak self] books in
            self?.presenter.hideLoadingView()
            let booksDtoList = books.items.map { BooksDto(bookId: $0.id,
                                                          title: $0.volumeInfo.title,
                                                          subtitle: $0.volumeInfo.subtitle,
                                                          imageUrl: $0.volumeInfo.imageLinks.thumbnail,
                                                          isFavorite: self?.verifyIfIsFavorite(bookId: $0.id) ?? false)
            }
            self?.booksList.append(contentsOf: booksDtoList)
            self?.presenter.showBooksList(books: self?.booksList ?? [])
        }, failure: { [weak self] error in
            self?.presenter.hideLoadingView()
            self?.presenter.presentError(message: error.localizedDescription)
        })
    }
    
    func listAllBooks() {
        presenter.showBooksList(books: booksList)
    }
    
    func listAllFavoriteBooks() {
        let favoriteBooksIds = fetchFavoriteBooks()
        let favoriteBooks = booksList.filter { favoriteBooksIds.contains($0.bookId) }
        
        presenter.presentFavoriteBooks(books: favoriteBooks)
    }
    
    private func fetchFavoriteBooks() -> [String] {
        var favoriteBooks: [String] = []
        
        if let books = UserDefaults.standard.object(forKey: "favorite") as? [String] {
            favoriteBooks = books
        }
        
        return favoriteBooks
    }
    
    private func verifyIfIsFavorite(bookId: String) -> Bool {
        let favoriteBooks = fetchFavoriteBooks()
        
        return favoriteBooks.contains(bookId)
    }
    
    func setBookAsFavorite(bookId: String) {
        let favoriteBooks = fetchFavoriteBooks()
        
        if !favoriteBooks.contains(bookId) {
            UserDefaults.standard.set(favoriteBooks, forKey: "favorite")
        }
    }
    
    func removeFromFavorite(bookId: String) {
        var favoriteBooks = fetchFavoriteBooks()
        
        favoriteBooks = favoriteBooks.filter({ $0 != bookId })
        
        UserDefaults.standard.set(favoriteBooks, forKey: "favorite")
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
