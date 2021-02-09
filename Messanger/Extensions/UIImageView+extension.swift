//
//  UIView+extension.swift
//  Messanger
//
//  Created by Rodion on 3/21/19.
//  Copyright © 2019 Rodion. All rights reserved.
//

import UIKit

extension UIImageView{
    func setRounded(){
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}
