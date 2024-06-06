//
//  ApiProvider.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 27-02-24.
//

import Foundation

enum DragonballError : Error , CustomStringConvertible{
    case server(error: Error)
    case statusCode(code: Int)
    case noData
    case parsingData
    
    var description: String {
        switch self {
        case .server(let error):
            return error.localizedDescription
        case .statusCode(let code):
            return "Received error status code \(code)"
        case .noData:
            return "No Data received from service"
        case .parsingData:
            return "Error parsing data"
        }
    }
}

//Endpoints de la api
enum DragonballEndpoint {
    case login
    case heroes
    case transformations
    case locations
    
    func endpoit() -> String {
        switch self {
        case .login:
            return "api/auth/login"
        case .heroes:
            return "api/heros/all"
        case .transformations:
            return "api/heros/tranformations"
        case .locations:
            return "api/heros/locations"
        }
    }
    
    func httpMethod() -> String {
        switch self {
        case .login, .heroes, .transformations, .locations:
            return "POST"
        }
    }
}

//Crea request para un endpoint dado
struct RequestProvider {
    let host = URL(string: "https://dragonball.keepcoding.education")!
    
    func requestFor(endPoint: DragonballEndpoint) -> URLRequest {
        let url = host.appendingPathComponent(endPoint.endpoit())
        var request = URLRequest.init(url: url)
        request.httpMethod = endPoint.httpMethod()
        return request
    }
    
    func requestFor(endPoint: DragonballEndpoint, token:String, params: [String: Any]) -> URLRequest {
        
        var request = self.requestFor(endPoint: endPoint)
        let jsonParameters = try? JSONSerialization.data(withJSONObject: params)
        request.httpBody = jsonParameters
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}

    
    class ApiProvider {
        
        private var session: URLSession
        private var requestProvider: RequestProvider
        private var secureData: SecureDataProtocol
        
        //Creamos ApiPRovider con session, requestPRovider y secureData
        // Al inyectarlos nos prmitirápasar los valores que necesitamos al crear la clase
        //especialmente útil para testing, se asignan valores por defecto si se proveen
        
        init(session: URLSession = URLSession.shared,
             requestProvider: RequestProvider = RequestProvider(),
             secureData: SecureDataProtocol = SecureDataKeychain()) {
            self.session = session
            self.requestProvider = requestProvider
            self.secureData = secureData
        }
        
        
        //Llamada al servicio login
        func loginWith(email: String, password: String, completion: @escaping (Result<Bool, DragonballError>) -> Void) {
            guard let loginData = String(format: "%@:%@", email, password).data(using: .utf8)?.base64EncodedString() else {
                completion(.failure(.parsingData))
                return
            }
            var request = requestProvider.requestFor(endPoint: .login)
            request.setValue("Basic \(loginData)", forHTTPHeaderField: "Authorization")
            makeRequestfor(request: request, completion: completion)
        }
        
        func getHeroesWith(name: String? = nil, completion: @escaping (Result<[Hero], DragonballError>) -> Void) {
            

            
            let token = secureData.getToken() ?? ""
            //print("token: \(token)")
            let request = requestProvider.requestFor(endPoint: .heroes, token: token, params: ["name": name ?? ""])
            makeDataRequestfor(request: request, completion: completion)
        }
        
        func getLocationsForHeroWith(id: String,
                                     completion: @escaping (Result<[Location], DragonballError>) -> Void) {

            
            let token = secureData.getToken() ?? ""
            //print("token: \(token)")
            let request = requestProvider.requestFor(endPoint: .locations, token: token, params: ["id": id])
            makeDataRequestfor(request: request, completion: completion)
        }
        
        func getTransformationsForHeroWith(id: String,
                                           completion: @escaping (Result<[Transformation], DragonballError>) -> Void) {

            let token = secureData.getToken() ?? ""
            let request = requestProvider.requestFor(endPoint: .transformations, token: token, params: ["id": id])
            makeDataRequestfor(request: request, completion: completion)
        }
    }
    

extension ApiProvider {
    
    func makeRequestfor(request: URLRequest, completion: @escaping (Result<Bool, DragonballError>) -> Void) {
        
        session.dataTask(with: request) { data, response, error in
            
            
            if let error {
                completion(.failure(.server(error: error)))
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode,
               statusCode != 200 {
                completion(.failure(.statusCode(code: statusCode)))
                return
            }
            
            if let data {
                if let token = String(data: data, encoding: .utf8) {
                    self.secureData.setToken(value: token)
                    completion(.success(true))
                } else {
                    completion(.failure(.parsingData))
                }
            } else {
                completion(.failure(.noData))
            }
        }.resume()
    }
    
    func makeDataRequestfor<T: Decodable>(request: URLRequest, completion: @escaping (Result<[T], DragonballError>) -> Void) {
        
        session.dataTask(with: request) { data, response, error in
            print(error?.localizedDescription as Any)

            
            if let error {
                completion(.failure(.server(error: error)))
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode,
               statusCode != 200 {
                completion(.failure(.statusCode(code: statusCode)))
                return
            }
            
            if let data {
                do {
                    let dataReceived = try JSONDecoder().decode([T].self, from: data)
                    completion(.success(dataReceived))
                } catch {
                    completion(.failure(.parsingData))
                   print("PArsing Data Error passing error")
                }
            } else {
                completion(.failure(.noData))
                print("No data received error")
            }
        }.resume()
    }
}

