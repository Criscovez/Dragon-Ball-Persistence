//
//  }heroDetailViewModelTest.swift
//  Dragon-Ball-PersistenceTests
//
//  Created by Cristian Contreras Velásquez on 01-06-24.
//

import XCTest
@testable import Dragon_Ball_Persistence

final class HeroDetailViewModelTest: XCTestCase {
    var sut: HeroDetailViewModel!
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

        let newHero = Hero(id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94", name: "Goku", description: "Sobran las presentaciones cuando se habla de Goku. El Saiyan fue enviado al planeta Tierra, pero hay dos versiones sobre el origen del personaje. Según una publicación especial, cuando Goku nació midieron su poder y apenas llegaba a dos unidades, siendo el Saiyan más débil. Aun así se pensaba que le bastaría para conquistar el planeta. Sin embargo, la versión más popular es que Freezer era una amenaza para su planeta natal y antes de que fuera destruido, se envió a Goku en una incubadora para salvarle.", photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300", favorite: false)
        storeDataProvider.insert(heroes: [newHero])
        


        
        sut = HeroDetailViewModel(apiProvider: apiProvider, hero: storeDataProvider.fetchHeroes().first!, storeDataProvider: storeDataProvider)
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
            var mockFile = ""
            print(url.lastPathComponent)
            if url.lastPathComponent == "all" {

                mockFile = "MockHeroes"
            } else {
                mockFile = "MockTransformations"
            }
            
            //Obtenemos el Bundle de target de Test, la url del fichero json y creamos Data
            let bundle = Bundle(for: type(of: self))
            let mockURL = try XCTUnwrap(bundle.url(forResource: mockFile, withExtension: "json"))
            let data = try Data(contentsOf: mockURL)
            
            //Creamos el response para el Handler
            let response = try XCTUnwrap(MockURLProtocol.urlResponseFor(url: url))
            
            return (response, data)
        }
        //When
        //Creamos al eexpectation y llamamos a loadData. Antes hay que crear el closure para loadData
        let expectation = expectation(description: "ViewModel load Heroes and Developers")
        
        sut.stateChanged = { [weak self] state in
            //Testamso la información recuperada por el ViewModel
            
            switch state {
                
            case .loading:
                print("loading")
                
            case .updated:
                
                XCTAssertEqual(self?.sut.numberOfTransformations(), 14)
                let indexPath = IndexPath(row: 0, section: 0)
                let trasformation = self?.sut.transformationAt(indexPath:indexPath)
                XCTAssertEqual(trasformation?.name, "1. Oozaru – Gran Mono")
                XCTAssertEqual(trasformation?.id, "17824501-1106-4815-BC7A-BFDCCEE43CC9")
                XCTAssertEqual(trasformation?.hero?.transformations.count,  14)
                
                expectation.fulfill()
                
            case .error(_):
                print("error")
            }

        }
        sut.loadData()

        //Then
        wait(for: [expectation], timeout: 4.0)
    }
}
