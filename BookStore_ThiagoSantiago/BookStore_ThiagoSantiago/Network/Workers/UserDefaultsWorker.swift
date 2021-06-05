//
//  UserDefaultsWorker.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 04/06/21.
//

import Foundation

protocol UserDefaultsWorking: AnyObject {
    func saveItem(itemId: String)
    func removeItem(itemId: String)
    func getItemsSaved() -> [String]
}

final class UserDefaultsWorker: UserDefaultsWorking {
    private let userDefaults = UserDefaults.standard
    
    func saveItem(itemId: String) {
        var itemsSaved = getItemsSaved()
        
        if !itemsSaved.contains(itemId) {
            itemsSaved.append(itemId)
            userDefaults.set(itemsSaved, forKey: "BooksListFavoriteIds")
            userDefaults.synchronize()
        }
    }
    
    func removeItem(itemId: String) {
        var itemsSaved = getItemsSaved()
        
        itemsSaved.removeAll(where: { $0 == itemId})
        userDefaults.set(itemsSaved, forKey: "BooksListFavoriteIds")
        userDefaults.synchronize()
    }
    
    func getItemsSaved() -> [String] {
        var itemsSaved: [String] = []
        
        if let items = userDefaults.object(forKey: "BooksListFavoriteIds") as? [String] {
            itemsSaved = items
        }
        
        return itemsSaved
    }
}
