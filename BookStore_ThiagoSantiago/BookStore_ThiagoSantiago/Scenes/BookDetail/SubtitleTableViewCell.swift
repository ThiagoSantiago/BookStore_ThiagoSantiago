//
//  SubtitleTableViewCell.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 05/06/21.
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subtitleLabel: UILabel!

    func setCellContent(subtitle: String) {
        subtitleLabel.text = subtitle
    }
}
