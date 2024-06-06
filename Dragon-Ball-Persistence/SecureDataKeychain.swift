//
//  SecureData.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 28-02-24.
//

import Foundation
import KeychainSwift

protocol SecureDataProtocol {
    func setToken(value: String)
    func getToken() -> String?
    func deleteToken()
}

class SecureDataKeychain: SecureDataProtocol {
    
    private let keychain = KeychainSwift()
    private let keyToken = "keyToken"
    
    func setToken(value: String) {
        keychain.set(value, forKey: keyToken)
    }
    
    func getToken() -> String? {
        keychain.get(keyToken)
    }
    
    func deleteToken() {
        keychain.delete(keyToken)
    }
}


