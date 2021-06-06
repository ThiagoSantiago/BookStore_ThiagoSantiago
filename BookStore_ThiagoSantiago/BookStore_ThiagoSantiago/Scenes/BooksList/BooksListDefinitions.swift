//
//  BooksListDefinitions.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 04/06/21.
//

import Foundation

struct BooksListDefinitions {
    
    struct Strings {
        static let viewTitle = "Books list"
        static let errorTitle = "Oops!"
        static let cellIndentifier = "BooksListItemCollectionViewCell"
    }
    
    struct Ints {
        static let cornerRadius: Int = 10
        static let cellWidthMargin: Int = 26
    }
}

struct BooksDto: Hashable {
    let bookId: String
    let title: String
    let subtitle: String?
    let imageUrl: String
    var isFavorite: Bool
    let description: String
    let authors: [String]?
    let numberOfPages: Int?
    let publisher: String?
    let buyLink: String?
}
