//
//  DiffieHelmann.swift
//  Messanger
//
//  Created by Rodion on 3/21/19.
//  Copyright © 2019 Rodion. All rights reserved.
//

import Foundation

class DiffiHelmanEncryptor {
    private let publicKey1: Int
    private let publicKey2: Int
    private let privateKey: Int
    private var fullKey: Int?
    
    init(publicKey1: Int, publicKey2: Int, privateKey: Int) {
        self.publicKey1 = publicKey1
        self.publicKey2 = publicKey2
        self.privateKey = privateKey
        self.fullKey = nil
    }
    
    private func power(first: Int, second: Int, third: Int) -> Int {
        if second == 1 {
            return first
        } else {
            return Int(pow(Double(first), Double(second))) % third
        }
    }
    
    func generatePartialKey() -> Int {
        let partialKey = power(first: publicKey2, second: privateKey, third: publicKey1)
        return partialKey
    }
    
    func generateFullKey(partialKey: Int) {
        fullKey = power(first: partialKey, second: privateKey, third: publicKey1)
    }
    
    func encrypt(message: String, partialKey: Int) -> String {
        let key = power(first: partialKey, second: privateKey, third: publicKey1)
        return CeasarCypher.encrypt(key: key, message: message)
    }
    
    func decrypt(message: String, partialKey: Int) -> String {
        let key = power(first: partialKey, second: privateKey, third: publicKey1)
        return CeasarCypher.decrypt(key: key, message: message)
    }
}
