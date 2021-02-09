//
//  UIAlertController+extension.swift
//  Messanger
//
//  Created by Rodion on 3/21/19.
//  Copyright © 2019 Rodion. All rights reserved.
//

import UIKit

extension UIAlertController{
    static func presentNoInternetAlertMessage() -> UIAlertController{
        let alert = UIAlertController(title: "Internet Connection", message: "Your device is not connected to the Internet. Turn on cellular data or use Wi-Fi to access data.", preferredStyle: UIAlertController.Style.alert)
        let settingsUrl = URL(string: "App-Prefs:root=WIFI")!
        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { (action) in
            UIApplication.shared.open(settingsUrl)
        }))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
}
