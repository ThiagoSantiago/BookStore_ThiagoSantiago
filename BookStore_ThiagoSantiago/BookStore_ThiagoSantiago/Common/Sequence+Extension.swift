//
//  Sequence+Extension.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 06/06/21.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
