//
//  LocalAccountTableViewCell.swift
//  Messanger
//
//  Created by Rodion on 3/21/19.
//  Copyright © 2019 Rodion. All rights reserved.
//

import UIKit

class LocalAccountTableViewCell: UITableViewCell {

    @IBOutlet private weak var ibUserNameLabel: UILabel!
    var textLabelColor: UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCellInfo(name: String){
        ibUserNameLabel.text = name
        ibUserNameLabel.textColor = textLabelColor
    }

}
