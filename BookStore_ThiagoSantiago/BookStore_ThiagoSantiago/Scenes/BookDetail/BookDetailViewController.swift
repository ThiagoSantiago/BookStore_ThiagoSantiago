//
//  BookDetailViewController.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 05/06/21.
//

import Foundation
import UIKit

protocol BookDetailDisplaying: AnyObject {
    func showBookContent(book: BooksDto)
}

final class BookDetailViewController: BaseViewController {
    
    typealias Strings = BookDetailDefinitions.Strings
    typealias Ints = BookDetailDefinitions.Ints
    typealias Colors = BookDetailDefinitions.Colors
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var book: BooksDto?
    private let interactor: BookDetailInteracting
    
    init(interactor: BookDetailInteracting) {
        self.interactor = interactor
        super.init(nibName: "BookDetailViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        interactor.setBookContent()
        configView()
    }
    
    private func configView() {
        title = Strings.viewTitle
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        
        bookImage.layer.cornerRadius = CGFloat(Ints.cornerRadius)
        containerView.layer.cornerRadius = CGFloat(Ints.cornerRadius)
        
        bookImage.layer.borderWidth = 1
        bookImage.layer.borderColor = Colors.darkBlue.cgColor
        
        registerCells()
        addBuyButtonInNavigationBar()
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: Strings.titlCellIndentifier, bundle: Bundle.main), forCellReuseIdentifier: Strings.titlCellIndentifier)
        tableView.register(UINib(nibName: Strings.subtitlCellIndentifier, bundle: Bundle.main), forCellReuseIdentifier: Strings.subtitlCellIndentifier)
        tableView.register(UINib(nibName: Strings.keyValueCellIndentifier, bundle: Bundle.main), forCellReuseIdentifier: Strings.keyValueCellIndentifier)
    }
    
    private func addBuyButtonInNavigationBar() {
        let favoritesBarButton = UIButton(type: .custom)
        favoritesBarButton.setImage(UIImage(named: "icon_cart"), for: .normal)
        favoritesBarButton.backgroundColor = Colors.darkBlue
        favoritesBarButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        favoritesBarButton.layer.cornerRadius = CGFloat(Ints.cartButtonCornerRadius)
        favoritesBarButton.addTarget(self, action: #selector(buyButtonPressed), for: .touchUpInside)
        favoritesBarButton.isHidden = interactor.shouldHideCart
        
        let rightBarButton = UIBarButtonItem(customView: favoritesBarButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc
    private func buyButtonPressed() {
        interactor.buyButtonTapped()
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        favoriteButton.isSelected = !favoriteButton.isSelected
        if favoriteButton.isSelected {
            interactor.setBookAsFavorite()
        } else {
            interactor.removeBookFromFavorites()
        }
    }
}

extension BookDetailViewController: BookDetailDisplaying {
    func showBookContent(book: BooksDto) {
        self.book = book
        bookImage.loadImage(from: book.imageUrl)
        favoriteButton.isSelected = book.isFavorite
        tableView.reloadData()
    }
}

extension BookDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Ints.tableNumberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch CellType(rawValue: indexPath.row) {
        case .title:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Strings.titlCellIndentifier, for: indexPath) as?  TitleTableViewCell else { return UITableViewCell() }
            cell.setCellContent(title: book?.title ?? "")
            return cell
        case .subtitle:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Strings.subtitlCellIndentifier, for: indexPath) as? SubtitleTableViewCell else { return UITableViewCell() }
            cell.setCellContent(subtitle: book?.subtitle ?? "")
            return cell
        case .bookPages:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Strings.keyValueCellIndentifier, for: indexPath) as? KeyValueTableViewCell else { return UITableViewCell() }
            cell.setCellContent(key: Strings.numberOfPagesTitle, value: "\(book?.numberOfPages ?? 0)")
            return cell
        case .authors:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Strings.keyValueCellIndentifier, for: indexPath) as? KeyValueTableViewCell else { return UITableViewCell() }
            var authors = ""
            book?.authors?.forEach({ author in
                authors.append("\(author) / ")
            })
            cell.setCellContent(key: Strings.authorsTitle, value: authors)
            return cell
        case .publisher:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Strings.keyValueCellIndentifier, for: indexPath) as? KeyValueTableViewCell else { return UITableViewCell() }
            cell.setCellContent(key: Strings.publisherTitle, value: book?.publisher ?? "")
            return cell
        case .description:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Strings.keyValueCellIndentifier, for: indexPath) as? KeyValueTableViewCell else { return UITableViewCell() }
            cell.setCellContent(key: "", value: book?.description ?? "")
            return cell
        default:
            let cell = UITableViewCell()
            cell.backgroundColor = Colors.darkBlue
            return cell
        }
    }
}
