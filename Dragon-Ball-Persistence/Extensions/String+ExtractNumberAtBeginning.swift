//
//  String+ExtractNumberAtBeginning.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 05-06-24.
//

import Foundation

extension String {
    func extractNumberAtBeginning() -> Int? {
        let pattern = "^[0-9]+"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: self.utf16.count)
            if let match = regex.firstMatch(in: self, options: [], range: range) {
                if let numberRange = Range(match.range, in: self) {
                    let numberString = self[numberRange]
                    return Int(numberString)
                }
            }
        } catch {
            print("Error al crear la expresión regular: \(error)")
        }
        return nil
    }
}
