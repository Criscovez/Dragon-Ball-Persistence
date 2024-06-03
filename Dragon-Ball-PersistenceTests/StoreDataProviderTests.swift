//
//  Dragon_Ball_PersistenceTests.swift
//  Dragon-Ball-PersistenceTests
//
//  Created by Cristian Contreras Velásquez on 27-05-24.
//

import XCTest
@testable import Dragon_Ball_Persistence

final class StoreDataProviderTests: XCTestCase {
    
    var sut: StoreDataProvider!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = StoreDataProvider(storageType: .inMemory)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_insertHero() {
        //Given
        let initialCount = sut.fetchHeroes().count
        XCTAssertEqual(initialCount, 0)
        
        //When
        let newHero = Hero(id: "1", name: "Goku", description: "Test_1", photo: "foto_1", favorite: false)
        sut.insert(heroes: [newHero])
        
        //Then
        let finalCount = sut.fetchHeroes().count
        XCTAssertEqual(finalCount, 1)
        let hero = sut.fetchHeroes().first
        XCTAssertEqual(hero?.id, newHero.id)
        XCTAssertEqual(hero?.name, newHero.name)
        XCTAssertEqual(hero?.heroDescription, newHero.description)
        XCTAssertEqual(hero?.photo, newHero.photo)
        
    }
    
    func test_inserTransformation() {
        //Given
        let initialCount = sut.fetchTransformations().count
        XCTAssertEqual(initialCount, 0)
        
        
        //When
        let newTransformation = Transformation(id: "2", name: "Vegeta", description: "Test_2", photo: "foto_2", hero: nil)
        sut.insert(transformations: [newTransformation])
        
        //Then
        
        let finalcount = sut.fetchTransformations().count
        XCTAssertEqual(finalcount, 1)
        let transformation = sut.fetchTransformations().first
        XCTAssertEqual(transformation?.id, newTransformation.id)
        XCTAssertEqual(transformation?.name, newTransformation.name)
        XCTAssertEqual(transformation?.info, newTransformation.description)
        XCTAssertEqual(transformation?.photo, newTransformation.photo)
        
    }
    
    func test_inserLocation(){
        //Given
        let initialCount = sut.fetchLocations().count
        XCTAssertEqual(initialCount, 0)
        
        //When
        
        let newLocation = Location(id: "3",
                                date: "00:00 PM",
                                latitude: "100",
                                longitude: "100",
                                hero: nil)
        sut.insert(locations: [newLocation])
        
        //Then
        
        let finalCount = sut.fetchLocations().count
        XCTAssertEqual(finalCount, 1)
        let location = sut.fetchLocations().first
        XCTAssertEqual(location?.id, newLocation.id)
        XCTAssertEqual(location?.latitude, newLocation.latitude)
        XCTAssertEqual(location?.longitude, newLocation.longitude)
        XCTAssertEqual(location?.date, newLocation.date)
    }
    
    func test_updateHeroes(){
        
        //Given
        
        let newHero = Hero(id: "1", name: "Test_name_1", description: "Test_description_1", photo: "foto_1", favorite: true)
        sut.insert(heroes: [newHero])
        
        //When
        
        let newHero2 = Hero(id: "1", name: "Test_name_2", description: "Test_description_2", photo: "foto_2", favorite: true)
        sut.insert(heroes: [newHero2])
        
        //Then
        let hero = sut.fetchHeroes().first
        XCTAssertEqual(hero?.name, newHero2.name)
        let finalCount = sut.fetchHeroes().count
        XCTAssertEqual(finalCount, 1)
        
    }
    
    func test_updateTransformation(){
        
        //Given
        
        let newTransformation = Transformation(id: "1", name: "Test_name_1", description: "Test_description_1", photo: "foto_1", hero: nil)
        
        sut.insert(transformations: [newTransformation])
        
        //When
        
        let newTransformation2 = Transformation(id: "1", name: "Test_name_2", description: "Test_description_2", photo: "foto_2", hero: nil)
        sut.insert(transformations: [newTransformation2])
        
        //Then
        let transformation = sut.fetchTransformations().first
        XCTAssertEqual(transformation?.name, newTransformation2.name)
        let finalCount = sut.fetchTransformations().count
        XCTAssertEqual(finalCount, 1)
        
    }
    
    func test_updateLocation(){
        
        //Given
        
        let newLocation = Location(id: "1",
                                   date: "00:00 PM",
                                   latitude: "100",
                                   longitude: "100",
                                   hero: nil)
        
        sut.insert(locations: [newLocation])
        
        //When
        
        let newLocation2 = Location(id: "1",
                                    date: "00:01 PM",
                                    latitude: "200",
                                    longitude: "200",
                                    hero: nil)
        
        sut.insert(locations: [newLocation2])
        
        //Then
        let location = sut.fetchLocations().first
        XCTAssertEqual(location?.date, newLocation2.date)
        let finalCount = sut.fetchLocations().count
        XCTAssertEqual(finalCount, 1)
        
    }
    
    func test_clearBBDD() {
        //GIVEN
        let heroe = Hero(id: "1", name: "Test_name_2", description: "Test_description_2", photo: "foto_2", favorite: true)
        
        sut.insert(heroes: [heroe])
        
        let transformation =  Transformation(id: "1", name: "Test_name_1", description: "Test_description_1", photo: "foto_1", hero: nil)
        
        sut.insert(transformations: [transformation])
        
        let location = Location(id: "1",
                                date: "00:00 PM",
                                latitude: "100",
                                longitude: "100",
                                hero: nil)
        
        sut.insert(locations: [location])
        
        XCTAssertEqual(sut.fetchHeroes().count, 1)
        XCTAssertEqual(sut.fetchTransformations().count, 1)
        XCTAssertEqual(sut.fetchLocations().count, 1)
        
        //when
        sut.cleanBBDD()
        
        
        //Then
        XCTAssertEqual(sut.fetchHeroes().count, 0)
        XCTAssertEqual(sut.fetchTransformations().count, 0)
        XCTAssertEqual(sut.fetchLocations().count, 0)
  
    }

}
