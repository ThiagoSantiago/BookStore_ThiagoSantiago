//
//  BookDetailDefinitions.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 05/06/21.
//

import Foundation
import  UIKit

struct BookDetailDefinitions {
    
    struct Strings {
        static let viewTitle = "Book details"
        static let titlCellIndentifier = "TitleTableViewCell"
        static let subtitlCellIndentifier = "SubtitleTableViewCell"
        static let keyValueCellIndentifier = "KeyValueTableViewCell"
        static let numberOfPagesTitle = "Number of pages:"
        static let authorsTitle = "Authors"
        static let publisherTitle = "Publisher:"
    }
    
    struct Ints {
        static let cornerRadius: Int = 10
        static let cartButtonCornerRadius: Int = 15
        static let tableNumberOfCells: Int = 6
    }
    
    struct Colors {
        static let darkBlue = UIColor(red: 75/255, green: 127/255, blue: 173/255, alpha: 1)
    }
}

enum CellType: Int {
    case title = 0
    case subtitle
    case bookPages
    case authors
    case publisher
    case description
}
