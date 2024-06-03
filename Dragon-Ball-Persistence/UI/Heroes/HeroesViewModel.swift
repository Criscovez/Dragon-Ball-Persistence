//
//  HeroesViewModel.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 19-04-24.
//

import Foundation

//enum HeroesState {
//    case loading
//    case updated
//    case error(_ error: DragonballError)
//}

class HeroesViewModel {
    
    var dataUpdated: (() -> Void)?
    
    private let apiProvider: ApiProvider
    var storeDataProvider: StoreDataProviderProtocol
    private var heroes: [NSMHero] = []
    //private var heroeCellModels: [HeroCellModel] = []
    
    
    
//    private let secureStorage: SecureDataProtocol
//    private var heroeCellModels: [HeroCellModel] = []
    
   // var stateUpdated: ((HeroesState) -> Void)?
    
    init(apiProvider: ApiProvider = ApiProvider(), storeDataProvider: StoreDataProviderProtocol ) {
        self.apiProvider = apiProvider
        self.storeDataProvider = storeDataProvider
        
    }
    
//    func loadData() {
//        
//        // Borra la BBDD
//        // storeDataProvider.clearBBDD()
//        heroes = storeDataProvider.fetchBootCamps(sorting: self.sortDescriptor(ascending: false))
//        if bootcamps.isEmpty {
//            self.loadDataFromServices()
//        } else {
//            notifyDataUpdated()
//        }
//        
//        self.stateUpdated?(.loading)
//        apiPRovider.getHeroesWith(name: nil) { [weak self] result in
//            switch result {
//            case .success(let heroes):
//                DispatchQueue.main.async {
//                    self?.heroes = heroes
//                    print(heroes)
//                    print(heroes.count)
//                    self?.stateUpdated?(.updated)
//                }nil
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self?.stateUpdated?(.error(error))
//                }
//            }
//        }
//    }
    
    func loadData() {
        // Borra la BBDD
         //storeDataProvider.cleanBBDD()
        heroes = storeDataProvider.fetchHeroes(filter: nil, sorting: self.sortDescriptor(ascending: false))
        
        if heroes.isEmpty {
            self.loadDataFromServices()
        } else {
            notifyDataUpdated()
        }
    }
    
    func notifyDataUpdated() {
        DispatchQueue.main.async {
            self.dataUpdated?()
        }
    }
    
    func numberOfHeroes() -> Int {
        print(heroes.count)
        return heroes.count
        
    }
    
    func nameForHero(indexPath: IndexPath) -> String? {
        return heroAt(indexPath: indexPath)?.name
    }
    
    func imageForHero(indexPath: IndexPath) -> String? {
        return heroAt(indexPath: indexPath)?.photo
    }
    
    func heroAt(indexPath: IndexPath) -> NSMHero? {
        guard indexPath.row < heroes.count else {return nil }
        return heroes[indexPath.row]
    }
    
//    func heroCellModel(index: IndexPath) -> HeroCellModel {
//        return heroeCellModels[index.row]
//    }
//    
//   func hero(index: IndexPath) -> Hero {
//       return heroes[index.row]
//    }
//    
//    func logout() {
//        secureStorage.deleteToken()
//    }
//    
//    func sortHeroesByName(ascending: Bool) {
//        heroes.sort(using: SortDescriptor(\Hero.name, order: .forward))
//    }
    
    func loadDataFromServices() {
        
   
            apiProvider.getHeroesWith(name: nil) { [weak self] result in
                switch result {
                case .success(let heroes):
                    DispatchQueue.main.async {
                        self?.storeDataProvider.insert(heroes: heroes)//esto funciona
                        self?.heroes = self?.storeDataProvider.fetchHeroes(filter: nil, sorting: self?.sortDescriptor(ascending: false)) ?? []
                        
                        self?.notifyDataUpdated()//esto no funciona
                        //self?.mapDataToHeroCellModel()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        //self?.stateUpdated?(.error(error))
                    }
                }
            }
    
        
//        // LA cola es serire porque necesitamos que las operaciones se hagan en orden
//        let queueLoadData = DispatchQueue(label: "io.keepcoding.loaddata")
//        
//        let group = DispatchGroup()
//        
//        group.enter()
//        queueLoadData.async {
//            self.getBootcamps { error in
//                if let error {
//                    debugPrint(error.description)
//                }
//                group.leave()
//            }
//        }
//        
//        group.enter()
//        queueLoadData.async {
//            self.getDevelopers { error in
//                if let error {
//                    debugPrint(error.description)
//                }
//                group.leave()
//            }
//        }
//        
//        group.notify(queue: .main) {
//            self.notifyDataUpdated()
//        }
        //self.notifyDataUpdated()
    }
    
    private func sortDescriptor(ascending: Bool = true) -> [NSSortDescriptor] {
        let sort = NSSortDescriptor(keyPath: \NSMHero.name, ascending: ascending)
        return [sort]
    }
}
