//
//  LoginController.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 27-02-24.
//

import UIKit

class LoginController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorEmail: UILabel!
    
    @IBOutlet weak var errorPassword: UILabel!
    
    private let viewModel: LoginViewModel
    
    private let storeDataProvider: StoreDataProviderProtocol
    
    init(viewModel: LoginViewModel = LoginViewModel(), storeDataProvider: StoreDataProviderProtocol) {
        self.viewModel = viewModel
        self.storeDataProvider = storeDataProvider
        super.init(nibName: String(describing: LoginController.self),
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        

        viewModel.loginStateChanged = {[weak self] state in
            //TODO: - Controlar que puede fallar el servicio (Se puede pasar un parámetro estado por ejemplo en loginStateChanged
            switch state {
            case .success:
                self?.activityIndicator.stopAnimating()
                // Navegamos a Heroes Controller
                DispatchQueue.main.async {
                    // Si el login es con exito, navegamos a la pantalla de Heroes
                    let heroes = HerosListController(viewModel: HeroesViewModel(storeDataProvider: self!.storeDataProvider))
                    self?.navigationController?.pushViewController(heroes, animated: true)
                }
                
            case .failed:
                print("failed")
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                }
            case .loading:
                self?.activityIndicator.startAnimating()
            case .showErrorEmail:
                
                self?.errorEmail.isHidden = false
                
            case .showErrorPassword:
                
                self?.errorPassword.isHidden = false
            }
        }
    }

    @IBAction func loginTapped(_ sender: Any) {
        //viewModel.loginWith(email: "pmunoz08@gmail.es", password: "qwerty1")
        
        
        if !viewModel.validateLoginData(email: emailTextField.text, password: passwordTextField.text) {
            print("error login")
            return
        }
        
        viewModel.loginWith(email: emailTextField.text ?? "", password:  passwordTextField.text ?? "")
        clearTextFields()
        //self.activityIndicator.stopAnimating()
    }
    
    private func showMessage(_ text: String) {
        let alert = UIAlertController(title: "Atención",
                                      message: text,
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "Ok", style: .default)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    private func clearTextFields() {
        emailTextField.text = nil
        passwordTextField.text = nil
    }
    
    

}
