//
//  BookStoreApiServiceProtocol.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 29/05/21.
//

import Foundation

enum HTTPMethod: String {
    
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}

protocol BookStoreApiSetupProtocol {
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var parameters: [String : Any] { get }
    var headers: [String : String] { get }
}

extension BookStoreApiSetupProtocol {
    var headers: [String : String] {
        return [:]
    }
    
    var parameters: [String : Any] {
        return [:]
    }
}
