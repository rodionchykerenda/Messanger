//
//  CeasarCypher.swift
//  Messanger
//
//  Created by Rodion on 3/21/19.
//  Copyright © 2019 Rodion. All rights reserved.
//

import Foundation

class CeasarCypher {
    static let alphabet = ["А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "Ы", "Ь", "Э", "Ю", "Я"]
    
    static func encrypt(key: Int, message: String) -> String {
        var result = ""
        for character in message {
            guard alphabet.contains(character.uppercased()) else {
                result += String(character)
                continue
            }
            let charIndex = alphabet.firstIndex(of: character.uppercased())!
            let pos = (charIndex + key) % alphabet.count
            result += alphabet[pos]
        }
        return result
    }
    
    static func decrypt(key: Int, message: String) -> String {
        var result = ""
        for character in message {
            guard alphabet.contains(String(character)) else {
                result += String(character)
                continue
            }
            let charIndex = alphabet.firstIndex(of: String(character))!
            let pos = (charIndex - key) % alphabet.count
            result += alphabet[pos]
        }
        return result
    }
}
