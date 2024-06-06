//
//  HerosListController.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 20-04-24.
//

import UIKit

class HerosListController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    private var viewModel: HeroesViewModel
    
    private var secureData: SecureDataProtocol
    
    init(viewModel: HeroesViewModel, secureData: SecureDataProtocol = SecureDataKeychain()) {
        self.viewModel = viewModel
        self.secureData = secureData
        super.init(nibName: String(describing: HerosListController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        let nib = UINib(nibName: String(describing: HeroListCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: HeroListCell.reuseIdentifier)
        navigationItem.title = "Lista de Heroes"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.stateChanged = { [weak self] state in
            switch state {
                
            case .loading:
                self?.loading.startAnimating()
            case .updated:
                self?.loading.stopAnimating()
                self?.collectionView.reloadData()
            case .error(let error):
                self?.loading.stopAnimating()
                debugPrint(error)
            }
            self?.collectionView.reloadData()
        }
        viewModel.loadData()
        navigationController?.isNavigationBarHidden = true
    }
    
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        secureData.deleteToken()
        viewModel.storeDataProvider.cleanBBDD()
        navigationController?.popToRootViewController(animated: true)
    }
    
}


extension HerosListController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfHeroes()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroListCell.reuseIdentifier, for: indexPath)
        
        let nameHero = self.viewModel.nameForHero(indexPath: indexPath)
        let imageHero = self.viewModel.imageForHero(indexPath: indexPath)
        (cell as? HeroListCell)?.configureWith(name: nameHero)
        (cell as? HeroListCell)?.configureWith(image: imageHero)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let hero = viewModel.heroAt(indexPath: indexPath) else { return }
        let viewModel = HeroDetailViewModel(hero: hero, storeDataProvider: viewModel.storeDataProvider)
        let detailVC = HeroDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}


