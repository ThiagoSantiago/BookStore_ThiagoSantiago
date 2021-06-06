//
//  BooksList.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 29/05/21.
//

import Foundation

struct BooksList: Decodable {
    let totalItems: Int
    let items: [Book]
}

struct Book: Decodable {
    let id: String
    let selfLink: String
    let volumeInfo: BookInfo
    let saleInfo: BookSaleInfo
}

struct BookInfo: Decodable {
    let title: String
    let subtitle: String?
    let authors: [String]?
    let publisher: String?
    let publishedDate: String
    let description: String?
    let pageCount: Int?
    let printType: String
    let maturityRating: String
    let imageLinks: BookImageLinks
    let language: String
    let previewLink: String
    let infoLink: String
    let categories: [String]
    let averageRating: Int?
    let ratingCount: Int?
}

struct BookImageLinks: Decodable {
    let smallThumbnail: String
    let thumbnail: String
}

struct BookSaleInfo: Decodable {
    let country: String
    let saleability: String
    let isEbook: Bool
    let listPrice: BookPriceInfo?
    let retailPrice: BookPriceInfo?
    let buyLink: String?
}

struct BookPriceInfo: Decodable {
    let amount: Double
    let currencyCode: String
}

enum Saleability: String, Codable {
    case forSale = "FOR_SALE"
    case free = "FREE"
    case notForSale = "NOT_FOR_SALE"
}
