//
//  BookDetailPresenter.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 05/06/21.
//

import Foundation
import UIKit

protocol BookDetailPresenting: AnyObject {
    var viewController: BookDetailDisplaying? { get }
    func presentBookContent(book: BooksDto)
    func presentBuyLink(buylink: String)
}

final class BookDetailPresenter: BookDetailPresenting {
    weak var viewController: BookDetailDisplaying?
    
    func presentBookContent(book: BooksDto) {
        viewController?.showBookContent(book: book)
    }
    
    func presentBuyLink(buylink: String) {
        AppRouter.shared.openLink(urlString: buylink)
    }
}
