//
//  ApiProviderTest.swift
//  Dragon-Ball-PersistenceTests
//
//  Created by Cristian Contreras Velásquez on 27-05-24.
//

import XCTest
@testable import Dragon_Ball_Persistence

final class ApiProviderTest: XCTestCase {
    
    let host =  URL(string: "https://dragonball.keepcoding.education/api")!
    let token = "expectedToken"
    
    var sut: ApiProvider!
    
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        sut = ApiProvider(session: session)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        MockURLProtocol.handler = nil
        MockURLProtocol.error = nil
        sut = nil
    }
    
    func test_getHeroes() {
        
        //given
        let expectedToken = Hero(id: "14BB8E98-6586-4EA7-B4D7-35D6A63F5AA3", name: "Maestro Roshi", description: "Es un maestro de artes marciales que tiene una escuela, donde entrenará a Goku y Krilin para los Torneos de Artes Marciales. Aún en los primeros episodios había un toque de tradición y disciplina, muy bien representada por el maestro. Pero Muten Roshi es un anciano extremadamente pervertido con las chicas jóvenes, una actitud que se utilizaba en escenas divertidas en los años 80. En su faceta de experto en artes marciales, fue quien le enseñó a Go", photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/Roshi.jpg?width=300", favorite: false)
        
        MockURLProtocol.handler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            let url = try XCTUnwrap(request.url)
            XCTAssertEqual(url, self.host.appendingPathComponent("/heros/all"))
            
            let mockUrl = try XCTUnwrap(Bundle(for: type(of: self)).url(forResource: "MockHeroes", withExtension: "json"))
            let data = try Data(contentsOf: mockUrl)
            
            let response = try XCTUnwrap(MockURLProtocol.urlResponseFor(url: url))
            
            return(response, data)
        }
        
        //WHEN
        let expectation = expectation(description: "Load heroes")
        sut.getHeroesWith { result in
            switch result{
            case.success(let heroes):
                XCTAssertEqual(heroes.count, 16)
                let firstHero = heroes.first
                XCTAssertEqual(firstHero?.name, expectedToken.name)
                XCTAssertEqual(firstHero?.id, expectedToken.id)
            case.failure(_):
                XCTFail("Waiting for success")
            }
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 0.4)
        
    }
    
    func test_getHeroesWithError(){
        //Given
        MockURLProtocol.error = NSError(domain:"io.keepcoding.loadheroes", code: -1000)
        
        //WHEN
        let expectation = expectation(description: "Load heroes server error")
        sut.getHeroesWith { result in
            switch result{
            case.success(_):
                XCTFail("Waiting for error")
            case.failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 0.4)
        
    }
    
    func test_getHeroesErrorStatusCode() {
        //given
        MockURLProtocol.handler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            let url = try XCTUnwrap(request.url)
            XCTAssertEqual(url, self.host.appendingPathComponent("/heros/all"))
            let response = try XCTUnwrap(MockURLProtocol.urlResponseFor(url: url, statusCode: 401))
            return(response, Data())
        }
        
        //WHEN
        let expectation = expectation(description: "Load heroes error status code")
        sut.getHeroesWith { result in
            switch result{
            case.success(_):
                XCTFail("Waiting for success")
            case.failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.description, "Received error status code 401")
                
            }
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 0.4)
    }
    
    
    func test_getTrasnformations() {
        
        
        //given
        let expectedToken = Transformation(id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94",name: "1. Oozaru – Gran Mono", description: "Cómo todos los Saiyans con cola, Goku es capaz de convertirse en un mono gigante si mira fijamente a la luna llena. Así es como Goku cuando era un infante liberaba todo su potencial a cambio de perder todo el raciocinio y transformarse en una auténtica bestia. Es por ello que sus amigos optan por cortarle la cola para que no ocurran desgracias, ya que Goku mató a su propio abuelo adoptivo Son Gohan estando en este estado. Después de beber el Agua Ultra Divina, Goku liberó todo su potencial sin necesidad de volver a convertirse en Oozaru", photo: "https://areajugones.sport.es/wp-content/uploads/2021/05/ozarru.jpg.webp", hero: nil)
        
        MockURLProtocol.handler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            let url = try XCTUnwrap(request.url)
            XCTAssertEqual(url, self.host.appendingPathComponent("/heros/tranformations"))
            
            let mockUrl = try XCTUnwrap(Bundle(for: type(of: self)).url(forResource: "MockTransformations", withExtension: "json"))
            
            let data = try Data(contentsOf: mockUrl)
            
            let response = try XCTUnwrap(MockURLProtocol.urlResponseFor(url: url))

            return(response, data)
        }
        
        //WHEN
        let expectation = expectation(description: "Load transformation")
        sut.getTransformationsForHeroWith(id: "D1C73353-5256-4AA1-B125-944D5C00A78B") { result in
            switch result{
            case.success(let transfor):
                XCTAssertEqual(transfor.count, 14)
                let firstTransfor = transfor.first
                XCTAssertEqual(firstTransfor?.name, expectedToken.name)
            case.failure(_):
                XCTFail("Waiting for success")
            }
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 0.4)
        
    }
    
    func test_getTransformationsWithError(){
        //Given
        MockURLProtocol.error = NSError(domain:"io.keepcoding.loadtransformations", code: -1000)
        
        //WHEN
        let expectation = expectation(description: "Load transformation server error")
        sut.getTransformationsForHeroWith(id: "D1C73353-5256-4AA1-B125-944D5C00A78B") { result in
            switch result{
            case.success(_):
                XCTFail("Waiting for error")
            case.failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 0.4)
        
    }
    
    func test_getTransformationsErrorStatusCode() {
        //given
        MockURLProtocol.handler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            let url = try XCTUnwrap(request.url)
            XCTAssertEqual(url, self.host.appendingPathComponent("/heros/tranformations"))
            let response = try XCTUnwrap(MockURLProtocol.urlResponseFor(url: url, statusCode: 401))
            return(response, Data())
        }
        
        //WHEN
        let expectation = expectation(description: "Load transformation error status code")
        sut.getTransformationsForHeroWith(id: "D1C73353-5256-4AA1-B125-944D5C00A78B")  { result in
            switch result{
            case.success(_):
                XCTFail("Waiting for success")
            case.failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.description, "Received error status code 401")
                
            }
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 0.4)
    }
    
    
    
    
    func test_getLocation() {
        
        //given
        let expectedToken = Location(id: "B93A51C8-C92C-44AE-B1D1-9AFE9BA0BCCC", date: "2022-02-20T00:00:00Z", latitude: "35.71867899343361", longitude: "139.8202084625344", hero: nil)
        
        MockURLProtocol.handler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            let url = try XCTUnwrap(request.url)
            XCTAssertEqual(url, self.host.appendingPathComponent("/heros/locations"))
            
            let mockUrl = try XCTUnwrap(Bundle(for: type(of: self)).url(forResource: "MockLocations", withExtension: "json"))
            let data = try Data(contentsOf: mockUrl)
            
            let response = try XCTUnwrap(MockURLProtocol.urlResponseFor(url: url))
            
            
            
            return(response, data)
        }
        
        //WHEN
        let expectation = expectation(description: "Load Location")
        sut.getLocationsForHeroWith(id: "610246EB-CD5B-48AF-9A5D-6C9609A76684") { result in
            switch result{
            case.success(let Location):
                XCTAssertEqual(Location.count, 21)
                let firstLocation = Location.first
                XCTAssertEqual(firstLocation?.latitude, expectedToken.latitude)
            case.failure(_):
                XCTFail("Waiting for success")
            }
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 0.4)
        
    }
    
    func test_getLocationsWithError(){
        //Given
        MockURLProtocol.error = NSError(domain:"io.keepcoding.loadlocations", code: -1000)
        
        //WHEN
        let expectation = expectation(description: "Load location server error")
        sut.getLocationsForHeroWith(id: "D1C73353-5256-4AA1-B125-944D5C00A78B") { result in
            switch result{
            case.success(_):
                XCTFail("Waiting for error")
            case.failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 0.4)
        
    }
    func test_getLocationsErrorStatusCode() {
        //given
        MockURLProtocol.handler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            let url = try XCTUnwrap(request.url)
            XCTAssertEqual(url, self.host.appendingPathComponent("/heros/locations"))
            let response = try XCTUnwrap(MockURLProtocol.urlResponseFor(url: url, statusCode: 401))
            return(response, Data())
        }
        
        //WHEN
        let expectation = expectation(description: "Load location error status code")
        sut.getLocationsForHeroWith(id: "D1C73353-5256-4AA1-B125-944D5C00A78B")  { result in
            switch result{
            case.success(_):
                XCTFail("Waiting for success")
            case.failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.description, "Received error status code 401")
                
            }
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 0.4)
    }
    
}
