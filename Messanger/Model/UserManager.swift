//
//  UserManager.swift
//  Messanger
//
//  Created by Rodion on 3/21/19.
//  Copyright © 2019 Rodion. All rights reserved.
//

import Foundation

class UserManager {
    static let shared = UserManager()
    private var isSender: Bool = true
    private var publicKey: Int = Int.random(in: 5...20)
    private var privateKey: Int = Int.random(in: 5...20)
    private var externalPublicKey: Int = 0
    private var partialKey: Int = 0
    
    func becomeSender(state: Bool) {
        self.isSender = state
    }
    
    func getPublicKey() -> Int {
        return publicKey
    }
    
    func setPublicKey(value: Int) {
        self.publicKey = value
    }
    
    func setExternalPublicKey(value: Int) {
        self.externalPublicKey = value
    }
    
    func setPrivateKey(value: Int) {
        self.privateKey = value
    }
    
    func setPartialKey(value: Int) {
        self.partialKey = value
    }
    
    func sendPublicKey() -> String {
        return "#\(publicKey)"
    }
    
    func sendPartialKey() -> String {
        let currentPublicKey = isSender ? publicKey : externalPublicKey
        let secondPublicKey = isSender ? externalPublicKey : publicKey
        let diffieHelmannEncryptor = DiffiHelmanEncryptor(publicKey1: currentPublicKey,
                                                          publicKey2: secondPublicKey,
                                                          privateKey: privateKey)
        return "|\(diffieHelmannEncryptor.generatePartialKey())"
    }
    
    func decrypt(message: String) -> String {
        let currentPublicKey = isSender ? publicKey : externalPublicKey
        let secondPublicKey = isSender ? externalPublicKey : publicKey
        let diffieHelmannEncryptor = DiffiHelmanEncryptor(publicKey1: currentPublicKey,
                                                          publicKey2: secondPublicKey,
                                                          privateKey: privateKey)
        return diffieHelmannEncryptor.decrypt(message: message, partialKey: self.partialKey)
    }
    
    func encrypt(message: String) -> String {
        let currentPublicKey = isSender ? publicKey : externalPublicKey
        let secondPublicKey = isSender ? externalPublicKey : publicKey
        let diffieHelmannEncryptor = DiffiHelmanEncryptor(publicKey1: currentPublicKey,
                                                          publicKey2: secondPublicKey,
                                                          privateKey: privateKey)
        diffieHelmannEncryptor.generateFullKey(partialKey: self.partialKey)
        return diffieHelmannEncryptor.encrypt(message: message, partialKey: self.partialKey)
    }
}
