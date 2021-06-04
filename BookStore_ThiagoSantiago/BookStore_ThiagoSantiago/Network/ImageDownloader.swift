//
//  ImageDownloader.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 03/06/21.
//

import Foundation
import UIKit

struct ImageDownloader {
    private let cache: NSCache<NSString, UIImage>
    
    private init() {
        cache = NSCache<NSString, UIImage>()
    }
    
    static let shared = ImageDownloader()
    
    func loadImage(from url: URL, completion: @escaping ((UIImage?) -> Void)) {
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
        } else {
            URLSession.shared.dataTask(with: url) { [cache] (data, _, _) in
                guard let data = data, let image = UIImage(data: data) else { return }
                cache.setObject(image, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
                }.resume()
        }
    }
}
