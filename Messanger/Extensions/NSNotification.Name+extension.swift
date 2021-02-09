//
//  NSNotification.Name+extension.swift
//  Messanger
//
//  Created by Rodion on 3/21/19.
//  Copyright © 2019 Rodion. All rights reserved.
//

import Foundation

extension NSNotification.Name{
    static let NewUserJoinedChat = NSNotification.Name("NewUserJoinedChat")
    static let UserLeftChat = NSNotification.Name("UserLeftChat")
    static let StartUserAmount = NSNotification.Name("StartUserAmount")
    static let DidDecryptMessage = NSNotification.Name("PresentDecryptedMessage")
}
