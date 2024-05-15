//
//  LoginViewModel.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 29-02-24.
//

import Foundation

//indica al controller el estado
enum LoginState {
    case loading
    case success
    case failed
    case showErrorEmail
    case showErrorPassword
}


final class LoginViewModel {
    
    private let apiProvider: ApiProvider
    
    var loginStateChanged: ((LoginState) -> Void)?
    
    init(apiProvider: ApiProvider = ApiProvider()) {
        self.apiProvider = apiProvider
    }
    
    func validateLoginData(email: String?, password: String?) -> Bool {
        guard let email = email, isValid(email: email) else {
            self.loginStateChanged?(.showErrorEmail)
            return false
        }
        

        guard let password = password, isValid(password: password) else {
            self.loginStateChanged?(.showErrorPassword)
            return false
        }
        return true
    }
    
    //Check email
    private func isValid(email: String) -> Bool {
        email.isEmpty == false && email.contains("@")
    }
    
    //Check Password
    private func isValid(password: String) -> Bool {
        password.isEmpty == false && password.count >= 4
    }
    
    func loginWith(email: String, password: String) {
        self.loginStateChanged?(.loading)
        apiProvider.loginWith(email: email, password: password) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    print("resultado: \(result)")
                    self?.loginStateChanged?(.success)
                }
            case .failure(let error):
                self?.loginStateChanged?(.failed)
                debugPrint("Error en loginWith loginviewmodel \(error.localizedDescription)")
            }
        }
    }
}
