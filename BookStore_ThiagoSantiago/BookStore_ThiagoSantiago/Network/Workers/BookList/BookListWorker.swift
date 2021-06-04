//
//  BookListWorker.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 29/05/21.
//

import Foundation

protocol  BooksListWorking {
    func getBooksList(pageIndex: Int, success: @escaping (_ books: BooksList) -> Void, failure: @escaping (_ error: BookStoreApiError) -> Void)
}

final class BooksListWorker: BooksListWorking {
    typealias Failure = (_ error: BookStoreApiError) -> Void
    
    let requester: BookStoreApiRequestProtocol
    var users: BooksList?
    
    init(requester: BookStoreApiRequestProtocol = BookStoreApiRequest()) {
        self.requester = requester
    }
    
    typealias GetBooksListSuccess = (_ books: BooksList) -> Void
    func getBooksList(pageIndex: Int, success: @escaping GetBooksListSuccess, failure: @escaping Failure) {
        requester.request(BookListApiServiceSetup.getBooks(itemsPerPage: 20, index: pageIndex)) { result in
            switch result{
            case let .success(data):
                
                do {
                    let decoder = JSONDecoder()
                    let userssList = try decoder.decode(BooksList.self, from: data)
                    self.users = userssList
                    DispatchQueue.main.async {
                        success(userssList)
                    }
                } catch {
                    DispatchQueue.main.async {
                        failure(.couldNotParseObject)
                    }
                    
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    }
}
