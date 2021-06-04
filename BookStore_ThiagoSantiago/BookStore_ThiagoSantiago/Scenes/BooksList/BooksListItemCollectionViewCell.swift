//
//  BooksListItemCollectionViewCell.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 03/06/21.
//

import UIKit

protocol BooksListItemCellDelegate: AnyObject {
    func favoriteButtonPressed(bookId: String, isFavorite: Bool)
}

class BooksListItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var cellContainerView: UIView!
    @IBOutlet weak var infoContainerView: UIView!
    
    private weak var delegate: BooksListItemCellDelegate?
    private var bookId: String = ""
    
    func setContent(book: BooksDto, delegate: BooksListItemCellDelegate) {
        titleLabel.text = book.title
        subtitleLabel.text = book.subtitle ?? ""
        itemImage.loadImage(from: book.imageUrl)
        favoriteButton.isSelected = book.isFavorite
        self.delegate = delegate
        self.bookId = book.bookId
        
        configView()
    }
    
    func configView() {
        cellContainerView.layer.cornerRadius = 10
        itemImage.layer.cornerRadius = 10
        favoriteButton.layer.cornerRadius = 12
    }
    
    @IBAction func favoriteBookTapped(_ sender: Any) {
        favoriteButton.isSelected = !favoriteButton.isSelected
        delegate?.favoriteButtonPressed(bookId: bookId, isFavorite: favoriteButton.isSelected)
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        itemImage.image = UIImage()
        subtitleLabel.text = ""
        favoriteButton.isSelected = false
    }
}
