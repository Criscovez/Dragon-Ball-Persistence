//
//  HeroDetailViewModel.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 19-04-24.
//

import Foundation


enum DetailHeroState {
    case updated
}

final class HeroDetailViewModel {
    
    private let apiProvider: ApiProvider
    private let storeDataProvider: StoreDataProviderProtocol
    private let hero: NSMHero
    
    private var transformationCellModels: [TransformationCellModel] = []
    private var transformations: [NSMTransformation] = []
    
    private var locations: [NSMLocation] = []
    
    var stateChanged: ((DetailHeroState) -> Void)?
    
    init(apiProvider: ApiProvider = ApiProvider(), hero: NSMHero, storeDataProvider: StoreDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.storeDataProvider = storeDataProvider
        self.hero = hero
        print("Hero: \(self.hero.transformations)")
    }
    
    deinit {
        debugPrint("Hero detail liberado")
    }
    
    
    func loadData() {
        print(hero.transformations)
        print(hero.locations)
        //transformations = storeDataProvider.fetchTransformations()//por que no llegan las transformaciones
        //locations = storeDataProvider.fetchLocations()
        
        if hero.transformations.isEmpty && hero.locations.isEmpty {
            
            guard let id = hero.id else { return }
            
            var Error: DragonballError?
            let group = DispatchGroup()
            
            group.enter()
            loadLocationsForHeroWith(id: id) { error in
                if let error {
                    Error = error
                }
                group.leave()
            }
            
            group.enter()
            loadTrasformationsForHeroWith(id: id) { error in
                if let error {
                    Error = error
                }
                group.leave()
            }
            
            
            
            
            group.notify(queue: .main) {
                if let Error {
                    // TODO: - Manage Error
                    return
                }
                
                self.updatedData()
            }
        }else{
            self.updatedData()
        }
    }
    
    private func loadTrasformationsForHeroWith(id: String, completion: @escaping (DragonballError?) -> Void) {
        
        apiProvider.getTransformationsForHeroWith(id: id) { [weak self] result in
            switch result {
            case .success(let transformations):
                DispatchQueue.main.async {
                    self?.storeDataProvider.insert(transformations: transformations)
                    completion(nil)
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    private func loadLocationsForHeroWith(id: String, completion: @escaping (DragonballError?) -> Void) {
        
        apiProvider.getLocationsForHeroWith(id: id) { [weak self] result in
            switch result {
            case .success(let locations):
                DispatchQueue.main.async {
                    //self?.locations = locations
                    self?.storeDataProvider.insert(locations: locations)
                    //TODO: - Añadir localizaciones a BBDD
                    completion(nil)
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func numberOfTransformations() -> Int {
        //return hero.transformations.count
        return transformations.count
    }
    
    func nameForTransformation(indexPath: IndexPath) -> String? {
        return transformationAt(indexPath: indexPath)?.name
    }
    
    func imageForTransformation(indexPath: IndexPath) -> String? {
        return transformationAt(indexPath: indexPath)?.photo
    }
    
    func transformationAt(indexPath: IndexPath) -> NSMTransformation? {
        guard indexPath.row < transformations.count else {return nil }
        return transformations[indexPath.row]
    }
    
    func transformationInfo(index: IndexPath) -> TransformationCellModel {
        return transformationCellModels[index.row]
    }
    
    func transformation(index: IndexPath) -> NSMTransformation {
        return transformations[index.row]
    }
    
    private func updatedData() {
        
        transformations = Array(hero.transformations ?? Set<NSMTransformation>()).sorted(by: {$0.name ?? "" < $1.name ?? ""})
        //transformations = Array( storeDataProvider.fetchTransformations())
        //self.transformationCellModels = transformations.map({TransformationCellModel(name: $0.name, photo: $0.photo)})
        locations = storeDataProvider.fetchLocations()
        self.stateChanged?(.updated)
    }
    
    func heroNameAndId() -> (String?, String?) {
        return (hero.name, hero.id)
    }
    
    func getTitle() -> String {
        return hero.name ?? "No name"
    }
    
    func locationsHero() -> [NSMLocation] {
        return self.locations
    }
    
    func getDescription() -> String {
        return hero.heroDescription ?? "No Description available"
    }
}


