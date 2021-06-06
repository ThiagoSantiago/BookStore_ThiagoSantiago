//
//  KeyValueTableViewCell.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 05/06/21.
//

import UIKit

class KeyValueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    func setCellContent(key: String, value: String) {
        keyLabel.text = key
        valueLabel.text = value
    }
}
