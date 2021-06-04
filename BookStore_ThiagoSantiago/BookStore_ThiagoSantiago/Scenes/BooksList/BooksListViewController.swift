//
//  BooksListViewController.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 03/06/21.
//

import Foundation
import UIKit

protocol BookListDisplaying: AnyObject {
    func showLoaderView()
    func hideLoaderView()
    func showError(message: String)
    func showBooksContent(booksList: [BooksDto])
}

final class BooksListViewController: BaseViewController {
    
    // MARK: - Alias
    
    typealias Strings = BooksListDefinitions.Strings
    typealias Ints = BooksListDefinitions.Ints
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Private properties
    
    private let interactor: BooksListInteracting
    private var booksList: [BooksDto] = []
    private let favoritesBarButton = UIButton(type: .custom)
    
    // MARK: - Lifecycle
    
    init(interactor: BooksListInteracting) {
        self.interactor = interactor
        super.init(nibName: "BooksListViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        interactor.resetPages()
        interactor.loadData()
        configView()
    }
    
    private func configView() {
        title = Strings.viewTitle
        
        searchBar?.delegate = self
        searchBar?.showsCancelButton = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: Strings.cellIndentifier, bundle: Bundle.main),
                                forCellWithReuseIdentifier: Strings.cellIndentifier)
        
        addNavigationFavoriteButton()
    }
    
    private func addNavigationFavoriteButton() {
        favoritesBarButton.setImage(UIImage(named: "favDisabled"), for: .normal)
        favoritesBarButton.setImage(UIImage(named: "favEnabled"), for: .selected)
        favoritesBarButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        favoritesBarButton.addTarget(self, action: #selector(showFavorites), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem(customView: favoritesBarButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc
    private func showFavorites() {
        favoritesBarButton.isSelected = !favoritesBarButton.isSelected
        if favoritesBarButton.isSelected {
            interactor.listAllFavoriteBooks()
        } else {
            interactor.listAllBooks()
        }
    }
}

extension BooksListViewController: BookListDisplaying {
    func showBooksContent(booksList: [BooksDto]) {
        self.booksList = booksList
        collectionView.reloadData()
    }
    
    func showError(message: String) {
        showError(title: Strings.errorTitle, message: message)
    }
    
    func showLoaderView() {
        showLoader()
    }
    
    func hideLoaderView() {
        hideLoader()
    }
}

extension BooksListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return booksList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.cellIndentifier, for: indexPath) as? BooksListItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setContent(book: booksList[indexPath.row],
                        delegate: self)
        
        if indexPath.row == booksList.count - 1 && !interactor.isSearching && !interactor.showingFavorites {
            interactor.getNextPage()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor.moveToBookDetail(book: booksList[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (UIScreen.main.bounds.width - CGFloat(Ints.cellWidthMargin)) / 2
        return CGSize(width: Int(cellWidth), height: Int(cellWidth*1.8))
    }
}


extension BooksListViewController: BooksListItemCellDelegate {
    func favoriteButtonPressed(bookId: String, isFavorite: Bool) {
        if isFavorite {
            interactor.setBookAsFavorite(bookId: bookId)
        } else {
            interactor.removeFromFavorite(bookId: bookId)
        }
        
    }
}

extension BooksListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor.searchBook(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        hideKeyboard()
    }
    
    func hideKeyboard() {
        interactor.stopSearching()
        searchBar?.resignFirstResponder()
    }
}
