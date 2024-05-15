//
//  HeroesController.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 27-02-24.
//

import UIKit
import Kingfisher

class HeroesController: UIViewController {
    
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageHero: UIImageView!
    private let viewModel: HeroesViewModel
    
    private var secureData: SecureDataProtocol
    
//    init(secureData: SecureDataProtocol = SecureDataKeychain()) {
//        self.secureData = secureData
//        super.init(nibName: String(describing: HeroesController.self), bundle: nil)
//    }
    
    init(viewModel: HeroesViewModel, secureData: SecureDataProtocol = SecureDataKeychain()) {
        self.viewModel = viewModel
        self.secureData = secureData
        super.init(nibName: String(describing: HeroesController.self), bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        let nib = UINib(nibName: String(describing: HeroListCell.self), bundle: nil)
        //tableView.register(nib, forCellWithReuseIdentifier: String(describing: HeroCell.self))
        tableView.register(nib, forCellReuseIdentifier: String(describing: HeroListCell.self))
        btnLogout.accessibilityIdentifier = "btnHeroes-logout"
        tableView.accessibilityIdentifier = "heroes-collectionView"
        
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        viewModel.loadData()

        // Do any additional setup after loading the view.
        //LA cache la gestiona la librería por defecto
        imageHero.kf.setImage(with: URL(string: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300"), options: [.transition(.fade(1))])
        
    }

    @IBAction func logoutTapped(_ sender: Any) {
        secureData.deleteToken()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func detailTapped(_ sender: Any) {
        //Simula la selleción de una celda de un héroe
//        let hero = Hero(id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94", name: "Goku", heroDescription: "", photo: "", favorite: true)
//        let viewModel = HeroDetailViewModel(hero: hero)
//        let detailHeroVC = HeroDetailViewController(viewModel: viewModel)
//        navigationController?.pushViewController(detailHeroVC, animated: true)
        tableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension HeroesController: UITableViewDataSource, UITableViewDelegate  {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.numberOfHeroes()
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: HeroCell.reuseIdentifier,
//                                                      for: indexPath) as! HeroCell
//        cell.configureWith(model: viewModel.heroCellModel(index: indexPath))
//        return cell
//    }
    
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel.numberOfHeroes()
//    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCell.reuseIdentifier,
//                                                      for: indexPath) as! HeroCell
//        cell.configureWith(model: viewModel.heroCellModel(index: indexPath))
//        return cell
//    }
   
    
    //Revizar
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let hero = viewModel.hero(index: indexPath)
//        let viewModel = viewModel.detailHeroViewModelWith(hero: hero)
//        let trnasformationsvc = DetailHeroViewController(viewModel: viewModel)
//        navigationController?.pushViewController(trnasformationsvc, animated: true)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (collectionView.bounds.size.width / 2) - 10,
//                      height: ((collectionView.bounds.size.width / 2) - 10))
//    }
//}
