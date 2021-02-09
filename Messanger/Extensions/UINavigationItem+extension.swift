//
//  UINavigationItem+extension.swift
//  Messanger
//
//  Created by Rodion on 3/21/19.
//  Copyright © 2019 Rodion. All rights reserved.
//

import UIKit

extension UINavigationItem {
    
    func setTitle(_ title: String, subtitle: String, titleColor: UIColor, subtitleColor: UIColor) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 17.0)
        titleLabel.textColor = titleColor
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 12.0)
        subtitleLabel.textColor = subtitleColor
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.axis = .vertical
        
        self.titleView = stackView
    }
    
}
