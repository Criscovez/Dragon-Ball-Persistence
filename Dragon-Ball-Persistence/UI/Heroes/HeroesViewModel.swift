//
//  HeroesViewModel.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 19-04-24.
//

import Foundation
import CoreData

enum HeroesState {
    case loading
    case updated
    case error(_ error: DragonballError)
}

class HeroesViewModel {
    
    var stateChanged: ((HeroesState) -> Void)?
    
    private let apiProvider: ApiProvider
    var storeDataProvider: StoreDataProviderProtocol
    private var heroes: [NSMHero] = []
    
    init(apiProvider: ApiProvider = ApiProvider(), storeDataProvider: StoreDataProviderProtocol ) {
        self.apiProvider = apiProvider
        self.storeDataProvider = storeDataProvider
        self.addObservers()
        
    }
    
    
    func loadData() {
        // Borra la BBDD
         //storeDataProvider.cleanBBDD()
        heroes = storeDataProvider.fetchHeroes(filter: nil, sorting: self.sortDescriptor(ascending: false))
        
        if heroes.isEmpty {
            self.loadHeroes()
        } else {
            notifyDataUpdated()
        }
    }
    

    
    
    func loadHeroes() {
        
        self.stateChanged?(.loading)
            apiProvider.getHeroesWith(name: nil) { [weak self] result in
                switch result {
                case .success(let heroes):
                    DispatchQueue.main.async {
                        self?.storeDataProvider.insert(heroes: heroes)
                        self?.notifyDataUpdated()//esto no funciona
                       
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.stateChanged?(.error(error))
                    }
                }
            }

    }
    
    func notifyDataUpdated() {
        DispatchQueue.main.async {
            self.stateChanged?(.updated)
        }
    }
    
    func numberOfHeroes() -> Int {
       // print(heroes.count)
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
    
    private func sortDescriptor(ascending: Bool = true) -> [NSSortDescriptor] {
        let sort = NSSortDescriptor(keyPath: \NSMHero.name, ascending: ascending)
        return [sort]
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(forName: NSManagedObjectContext.didSaveObjectsNotification, object: nil, queue: .main) { notification in
            self.heroes = self.storeDataProvider.fetchHeroes(filter: nil, sorting: self.sortDescriptor(ascending: false))
        }
    }
}
