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

// SecureDataProtocol con Userdefaults para Testing
class SecureDataUserDefaults: SecureDataProtocol {
    
    private let userDefaults = UserDefaults.standard
    private let keyToken = "keyToken"
    
    func setToken(value: String) {
        userDefaults.setValue(value, forKey: keyToken)
    }
    
    func getToken() -> String? {
        userDefaults.value(forKey: keyToken) as? String
    }
    
    func deleteToken() {
        userDefaults.removeObject(forKey: keyToken)
    }
}
