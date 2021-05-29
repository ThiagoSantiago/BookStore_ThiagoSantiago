//
//  BookListWorker.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 29/05/21.
//

import Foundation

final class BooksListWorker {
    typealias Failure = (_ error: BookStoreApiError) -> Void
    
    let requester: BookStoreApiRequestProtocol
    var users: BooksList = []
    
    init(requester: BookStoreApiRequestProtocol = BookStoreApiRequest()) {
        self.requester = requester
    }
    
    typealias GetBooksListSuccess = (_ books: BooksList) -> Void
    func getBooksList(success: @escaping GetBooksListSuccess, failure: @escaping Failure) {
        
        if users.isEmpty {
            requester.request(BookListApiServiceSetup.getBooks(itemsPerPage: 20, index: 0)) { result in
                switch result{
                case let .success(data):
                    
                    do {
                        let decoder = JSONDecoder()
                        let userssList = try decoder.decode(BooksList.self, from: data)
                        self.users = userssList
                        success(userssList)
                    } catch {
                        failure(.couldNotParseObject)
                    }
                case let .failure(error):
                    failure(error)
                }
            }
        } else {
            success(users)
        }
    }
}
