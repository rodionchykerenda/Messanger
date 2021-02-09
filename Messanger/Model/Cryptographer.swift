//
//  Encryptor.swift
//  Messanger
//
//  Created by Rodion on 3/21/19.
//  Copyright © 2019 Rodion. All rights reserved.
//

import Foundation

struct CompressionTableRow {
    let number: Int?
    let characters: [String]
    
    init(number: Int? = nil, characters: [String]) {
        self.number = number
        self.characters = characters
    }
}

struct CompressionTable {
    let rows: [CompressionTableRow]
    
    init() {
        self.rows = [
            .init(characters: ["А", "И", "Т", "Е", "С", "Н", "О"]),
            .init(number: 8, characters: ["Б", "В", "Г", "Д", "Ж", "З", "К", "Л", "М", "П"]),
            .init(number: 9, characters: ["Р", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "Ы"]),
            .init(number: 0, characters: ["Ь", "Э", "Ю", "Я", " "])
        ]
    }
    
    func getCharacterRowNumber(character: String, row: CompressionTableRow) -> Int? {
        for index in 0..<row.characters.count{
            if character.lowercased() == row.characters[index].lowercased() {
                let number = (index + 1) % 10
                return number
            }
        }
        return nil
    }
    
    private func convertCharacterLocationToString(rowNumber: Int?, columnNumber: Int) -> String {
        if let row = rowNumber {
            return "\(row)\(columnNumber)"
        } else {
            return "\(columnNumber)"
        }
    }
    
    func getCharacterNumber(character: String) -> String {
        var rowNumber: Int?
        var columnNumber: Int
        for row in rows {
            if let column = getCharacterRowNumber(character: character, row: row) {
                columnNumber = column
                rowNumber = row.number
                return convertCharacterLocationToString(rowNumber: rowNumber, columnNumber: columnNumber)
            }
        }
        fatalError("Error: no such character")
    }
}

class Cryptographer {
    private let compressionTable = CompressionTable()
    private var key: [Int] = []
    
    private func convertStringToIntArray(encodedString: String) -> [Int] {
        var data: [Int] = []
        for character in encodedString {
            guard let number = Int(String(character)) else {
                fatalError("Error: can not convert char to int")
            }
            data.append(number)
        }
        return data
    }
    
    private func convertIntArrayToString(data: [Int]) -> String {
        var result: String = ""
        for value in data {
            result += String(value)
        }
        return result
    }
    
    private func encodeText(text: String) -> [Int] {
        var encodedText: String = ""
        for character in text {
            encodedText += compressionTable.getCharacterNumber(character: String(character))
        }
        return convertStringToIntArray(encodedString: encodedText)
    }
    
    private func generateKey(length: Int) {
        var key: [Int] = []
        for _ in 0..<length {
            let number = Int.random(in: 0...9)
            key.append(number)
        }
        self.key = key
    }
    
    private func getRowByValue(value: Int) -> CompressionTableRow {
        for row in compressionTable.rows {
            if row.number == value {
                return row
            }
        }
        return compressionTable.rows[0]
    }
    
    func convertCodeToCharacter(decryptedData: [Int]) -> String {
        var decryptedText: String = ""
        var index = 0
        while index < decryptedData.count {
            let row = getRowByValue(value: decryptedData[index])
            if row.number != nil { index += 1 }
            let columnNumber = decryptedData[index]
            let position = columnNumber == 0 ? row.characters.count - 1 : columnNumber - 1
            decryptedText += row.characters[position]
            index += 1
        }
        return decryptedText
    }
    
    func getKey() -> String {
        return convertIntArrayToString(data: key)
    }
    
    func setKey(key: String) {
        self.key = convertStringToIntArray(encodedString: key)
    }
    
    func encrypt(text: String) -> String {
        var encryptedText: [String] = []
        // Encode input text
        let encodedText = encodeText(text: text)
        // Generate secret key
        generateKey(length: encodedText.count)
        // Encryption
        for index in 0..<encodedText.count {
            let value = (encodedText[index] + key[index]) % 10
            encryptedText.append(String(value))
        }
        return encryptedText.joined()
    }
    
    func decrypt(text: String) -> String {
        let encryptedText = convertStringToIntArray(encodedString: text)
        var decodedData: [Int] = []
        for index in 0..<encryptedText.count {
            let value = (encryptedText[index] + 10 - key[index]) % 10
            decodedData.append(value)
        }
        return convertCodeToCharacter(decryptedData: decodedData)
    }
}
