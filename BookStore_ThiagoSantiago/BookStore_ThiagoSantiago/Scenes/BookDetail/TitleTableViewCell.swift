//
//  TitleTableViewCell.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 05/06/21.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func setCellContent(title: String) {
        titleLabel.text = title
    }
}
