//
//  DragonBallViewModelTest.swift
//  Dragon-Ball-PersistenceTests
//
//  Created by Cristian Contreras Velásquez on 31-05-24.
//

import XCTest
@testable import Dragon_Ball_Persistence

final class HeroesViewModelTest: XCTestCase {
    var sut: HeroesViewModel!
    var apiProvider: ApiProvider!
    var storeDataProvider: StoreDataProvider!

    override func setUpWithError() throws {
        try super.setUpWithError()
        //Creamos las instancias de las classes que necesitamos
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        apiProvider = ApiProvider(session: session)
        storeDataProvider = StoreDataProvider(storageType: .inMemory)
        sut = HeroesViewModel(apiProvider: apiProvider, storeDataProvider: storeDataProvider)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        //Limpiamos las classes después de cada test
        apiProvider = nil
        storeDataProvider = nil
        sut = nil
    }
    
    func test_loadData() {
        //Given
        MockURLProtocol.handler = { request in
            let url = try XCTUnwrap(request.url)
            //Como hay 2 llamadas a servicios en el viewModel, necesitamso saber cuales son para determinar como crear el Data
            // para handler nos apoyamos en la lastComponet, para saber a que servicio se está llamando y crear Data de forma correcta
//            var mockFile = ""
//            print(url.lastPathComponent)
//            if url.lastPathComponent == "all" {
//                
//                mockFile = "MockHeroes"
//            } else {
//                mockFile = "MockLocations"
//            }
            
            //Obtenemos el Bundle de target de Test, la url del fichero json y creamos Data
            let bundle = Bundle(for: type(of: self))
            let mockURL = try XCTUnwrap(bundle.url(forResource: "MockHeroes", withExtension: "json"))
            let data = try Data(contentsOf: mockURL)
            
            //Creamos el response para el Handler
            let response = try XCTUnwrap(MockURLProtocol.urlResponseFor(url: url))
            
            return (response, data)
        }
        //When
        //Creamos al eexpectation y llamamos a loadData. Antes hay que crear el closure para loadData
        let expectation = expectation(description: "ViewModel load Heroes and Developers")
        sut.dataUpdated = { [weak self] in
            //Testamso la información recuperada por el ViewModel
            XCTAssertEqual(self?.sut.numberOfHeroes(), 16)
            let indexPath = IndexPath(row: 0, section: 0)
            let hero = self?.sut.heroAt(indexPath:indexPath)
            XCTAssertEqual(hero?.name, "Vegeta")
            XCTAssertEqual(hero?.id, "6E1B907C-EB3A-45BA-AE03-44FA251F64E9")
            
            //XCTAssertEqual(hero?.transformations.count, 13)
            
            expectation.fulfill()
        }
        sut.loadData()

        //Then
        wait(for: [expectation], timeout: 4.0)
    }
}
