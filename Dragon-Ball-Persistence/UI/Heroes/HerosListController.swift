//
//  HerosListController.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 20-04-24.
//

import UIKit

class HerosListController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
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
//        print("\(HeroListCell.reuseIdentifier)1")
//        print("\(String(describing: HeroListCell.self))2")
        navigationItem.title = "Lista de Heroes"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.dataUpdated = {
            self.collectionView.reloadData()
        }
        viewModel.loadData()
        navigationController?.isNavigationBarHidden = true
    }
    
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        secureData.deleteToken()
        navigationController?.popToRootViewController(animated: true)
    }
    
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        //let herox = Hero(id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94", name: "Goku", description: "", photo: "", favorite: true)
        let viewModel = HeroDetailViewModel(hero: hero, storeDataProvider: viewModel.storeDataProvider)
        let detailVC = HeroDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}


