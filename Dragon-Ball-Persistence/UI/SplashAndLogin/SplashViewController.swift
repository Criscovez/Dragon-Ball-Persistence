//
//  ViewController.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 27-02-24.
//

import UIKit

class SplashViewController: UIViewController {
    
    private var secureData: SecureDataProtocol
    private let storeDataProvider: StoreDataProviderProtocol = StoreDataProvider()
    
    init(secureData: SecureDataProtocol = SecureDataKeychain()) {
        self.secureData = secureData
        super.init(nibName: String(describing: SplashViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var destination: UIViewController
        if let token = secureData.getToken() {
            destination = HerosListController(viewModel: HeroesViewModel(storeDataProvider: storeDataProvider))
        } else {
            destination = LoginController(storeDataProvider: storeDataProvider)
        }
        
        navigationController?.pushViewController(destination, animated: true)
        
    }

}

