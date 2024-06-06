//
//  HeroDetailViewModel.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 19-04-24.
//

import Foundation
import CoreData


enum DetailHeroState {
    case updated
    case loading
    case error(_ error: DragonballError)
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
        addObservers()
    }
    
    deinit {
        debugPrint("Hero detail liberado")
    }
    
    
    func loadData() {
        
        self.transformations = Array(self.hero.transformations).sorted(by: {(transformation1, transformation2) -> Bool in
            if let number1 : Int = String.extractNumberAtBeginning(transformation1.name ?? "")(),
               let number2 : Int = String.extractNumberAtBeginning(transformation2.name ?? "")() {
                return number1 < number2
            }
            return false})

        self.locations = self.storeDataProvider.fetchLocations()
        
        
        
        if hero.transformations.isEmpty && hero.locations.isEmpty {
            
            guard let id = hero.id else { return }
            
            var dError: DragonballError?
            let group = DispatchGroup()
            
            group.enter()
            loadLocationsForHeroWith(id: id) { error in
                if let error {
                    dError = error
                }
                group.leave()
            }
            
            group.enter()
            loadTrasformationsForHeroWith(id: id) { error in
                if let error {
                    dError = error
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
                if let dError {
                    self.stateChanged?(.error(dError))
                    return
                }
                
                self.updatedData()
            }
        }else{
            self.updatedData()
        }
    }
    
    private func loadTrasformationsForHeroWith(id: String, completion: @escaping (DragonballError?) -> Void) {
        self.stateChanged?(.loading)
        apiProvider.getTransformationsForHeroWith(id: id) { [weak self] result in
            switch result {
            case .success(let transformations):
                DispatchQueue.main.async {
                    self?.storeDataProvider.insert(transformations: transformations)
                    completion(nil)
                    
                }
            case .failure(let error):
                completion(error)
                self?.stateChanged?(.error(error))
            }
        }
    }
    
    private func loadLocationsForHeroWith(id: String, completion: @escaping (DragonballError?) -> Void) {
        self.stateChanged?(.loading)
        apiProvider.getLocationsForHeroWith(id: id) { [weak self] result in
            switch result {
            case .success(let locations):
                DispatchQueue.main.async {
                    
                    self?.storeDataProvider.insert(locations: locations)
                    
                    completion(nil)
                    
                }
            case .failure(let error):
                completion(error)
                self?.stateChanged?(.error(error))
            }
        }
    }
    
    private func updatedData() {
 
        self.stateChanged?(.updated)
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

    private func addObservers() {
        NotificationCenter.default.addObserver(forName: NSManagedObjectContext.didSaveObjectsNotification, object: nil, queue: .main) { notification in
            self.transformations = Array(self.hero.transformations).sorted(by: {(transformation1, transformation2) -> Bool in
                if let number1 : Int = String.extractNumberAtBeginning(transformation1.name ?? "")(),
                   let number2 : Int = String.extractNumberAtBeginning(transformation2.name ?? "")() {
                    return number1 < number2
                }
                return false})

            self.locations = self.storeDataProvider.fetchLocations()
        }
    }
    
}
