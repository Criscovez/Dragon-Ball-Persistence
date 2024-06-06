//
//  StoreDataProvider.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 09-03-24.
//

import Foundation
import CoreData

protocol StoreDataProviderProtocol {
    func insert(heroes: [Hero])
    func fetchHeroes(filter: NSPredicate?, sorting:[NSSortDescriptor]?) -> [NSMHero]
    func countHeroes() -> Int
    func insert(transformations: [Transformation])
    func fetchTransformations(filter: NSPredicate?, sorting:[NSSortDescriptor]?) -> [NSMTransformation]
    func insert(locations: [Location])
    func fetchLocations() -> [NSMLocation]
    func cleanBBDD()
}

enum StorageType {
    case persisted
    case inMemory
}

class StoreDataProvider: StoreDataProviderProtocol {

    private let persistenContainer: NSPersistentContainer!
    
    //tal cual
    private static var model: NSManagedObjectModel = {
        let bundle = Bundle(for: StoreDataProvider.self)
        guard let url =  bundle.url(forResource: "Model", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to locate momd file")
        }
        return model
    }()
    
    lazy var moc: NSManagedObjectContext = {
        var viewcontext = persistenContainer.viewContext
        viewcontext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return viewcontext
    }()
    
    init(storageType: StorageType = .persisted) {
        self.persistenContainer = NSPersistentContainer(name: "Model", managedObjectModel: Self.model)

        if storageType == .inMemory, let persistentStore = self.persistenContainer.persistentStoreDescriptions.first {
            persistentStore.url = URL(fileURLWithPath: "/dev/null")
        }
        self.persistenContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError("No se ha podido ebtener el persistent Store")
            }
        }
    }
    
    func saveContext() {
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                print("Error saving context \(error.localizedDescription)")
            }
        }
    }
}

extension StoreDataProvider {
    
    func insert(heroes: [Hero]) {
        for hero in heroes {
            let newHero = NSMHero(context: moc)
            newHero.id = hero.id
            newHero.name = hero.name
            newHero.heroDescription = hero.description
            newHero.photo = hero.photo
            newHero.favorite = hero.favorite ?? false
        }
        saveContext()
    }
    
    func fetchHeroes(filter: NSPredicate? = nil, sorting: [NSSortDescriptor]? = nil) -> [NSMHero] {
        let request = NSMHero.fetchRequest()
        request.predicate = filter
        if sorting == nil {
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
        } else {
            request.sortDescriptors = sorting
        }
        
        do {
            return try moc.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func countHeroes() -> Int {
        let request = NSMHero.fetchRequest()
        do {
            return try moc.count(for: request)
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
    

    
    func insert(transformations: [Transformation]) {
        for transformation in transformations {
            let newTrandformation = NSMTransformation(context: moc)
            newTrandformation.id = transformation.id
            newTrandformation.name = transformation.name
            newTrandformation.info = transformation.description
            newTrandformation.photo = transformation.photo
            let filter = NSPredicate(format: "id == %@", transformation.hero?.id ?? "")
            let hero = fetchHeroes(filter: filter).first
            newTrandformation.hero = hero
            
        }
        saveContext()
    }
    
    func fetchTransformations(filter: NSPredicate? = nil, sorting: [NSSortDescriptor]? = nil) -> [NSMTransformation] {
        let request = NSMTransformation.fetchRequest()
        request.predicate = filter
        if sorting == nil {
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
        } else {
            request.sortDescriptors = sorting
        }
        
        do {
            return try moc.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
        
        func insert(locations: [Location]) {
            for location in locations {
                let newLocation = NSMLocation(context: moc)
                newLocation.id = location.id
                newLocation.latitude = location.latitude
                newLocation.longitude = location.longitude
                newLocation.date = location.date
                let filter = NSPredicate(format: "id == %@", location.hero?.id ?? "")
                let hero = fetchHeroes(filter: filter).first
                newLocation.hero = hero
                
            }
            saveContext()
        }
        
        func fetchLocations() -> [NSMLocation] {
            let request = NSMLocation.fetchRequest()
            do {
                return try moc.fetch(request)
            } catch {
                print(error.localizedDescription)
                return []
            }
        }
        

        
        func cleanBBDD() {
            moc.reset()
            let deleteHeroes = NSBatchDeleteRequest(fetchRequest: NSMHero.fetchRequest())
            let deleteTransformations = NSBatchDeleteRequest(fetchRequest: NSMTransformation.fetchRequest())
            let deleteLocations = NSBatchDeleteRequest(fetchRequest: NSMLocation.fetchRequest())
            
            for task in [deleteHeroes,deleteTransformations, deleteLocations] {
                do {
                    try moc.execute(task)
                } catch let error as NSError {
                    print("There was an error removing data from BBDD \(error)")
                }
            }
        }
    }

