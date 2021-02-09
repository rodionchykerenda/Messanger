//
//  UserTableViewCell.swift
//  Messanger
//
//  Created by Rodion on 3/21/19.
//  Copyright © 2019 Rodion. All rights reserved.
//

import UIKit
import LetterAvatarKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet private weak var ibUserAvatarView: UIImageView!
    @IBOutlet private weak var ibUserFullNameLabel: UILabel!
    
    var textLabelColor: UIColor?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func updateCell(user: User){
        ibUserAvatarView.setRounded()
        ibUserAvatarView.backgroundColor = user.color
        ibUserAvatarView.image = UIImage.makeLetterAvatar(withUsername: user.name)
        ibUserFullNameLabel.text = user.name
        ibUserFullNameLabel.textColor = textLabelColor
    }

}
