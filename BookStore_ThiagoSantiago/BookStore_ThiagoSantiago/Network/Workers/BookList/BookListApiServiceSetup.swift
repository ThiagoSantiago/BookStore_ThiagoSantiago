//
//  BookListApiServiceSetup.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 29/05/21.
//

import Foundation

enum BookListApiServiceSetup: BookStoreApiSetupProtocol {
    
    case getBooks(itemsPerPage: Int, index: Int)
    
    var endpoint: String {
        switch self {
        case let .getBooks(items, index):
            guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else { return "" }
            let url = baseUrl+"/books/v1/volumes?q=ios&maxResults=\(items)&startIndex=\(index)"
            
            return url
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getBooks:
            return .get
        }
    }
}
