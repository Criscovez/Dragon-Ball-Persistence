//
//  ApiProvider.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 27-02-24.
//

import Foundation

enum DragonballError : Error {
    case server(error: Error)
    case parsingData
    case statusCode(code: Int)
}
//enum GAFError: Error, CustomStringConvertible {
//    case service(error: Error)
//    case statusCode(code: Int)
//    case dataNoReceived
//    case parsingData(error: Error?)
//    case noToken
//    
//    var description: String {
//        switch self {
//        case .service(let error):
//            return "Received an error from service \(error.localizedDescription)"
//        case .statusCode(let code):
//            return "Failed request with status code \(code)"
//        case .dataNoReceived:
//            return "Data no received in service response"
//        case .parsingData(let error):
//            return "Error parsing data \(error?.localizedDescription ?? "")"
//        case .noToken:
//            return "No token for session found"
//        }
//    }
//}

//enum DragonballEndpoint {
//    case login
//    case heroes
//    case transformations
//    case locations
//    
//    func urlWith(host: URL) -> URL {
//        switch self {
//        case .login:
//            return host.appendingPathComponent("api/auth/login")
//        case .heroes:
//            return host.appendingPathComponent("api/heros/all")
//        case .transformations:
//            return host.appendingPathComponent("api/heros/tranformations")
//        case .locations:
//            return host.appendingPathComponent("api/heros/locations")
//        }
//    }
//    
//}

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

//struct RequestProvider {
//    let host = URL(string: "https://dragonball.keepcoding.education")!
//    
//    func httpMethodFor(endpoint: DragonballEndpoint) -> String {
//        switch endpoint {
//            
//        case .login:
//            return "POST"
//        }
//    }
//    
//    func requestFor(endpoint: DragonballEndpoint) -> URLRequest {
//        switch endpoint {
//        case .login:
//            var request = URLRequest.init(url: endpoint.urlWith(host: host))
//            request.httpMethod = self.httpMethodFor(endpoint: .login)
//            return request
//        }
//    }
//    
//    func requestFor(endPoint: DragonballEndpoint, token:String, params: [String: Any]) -> URLRequest {
//        
//        var request = self.requestFor(endpoint: endPoint)
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        let jsonParameters = try? JSONSerialization.data(withJSONObject: params)
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonParameters
//        
//        return request
//    }
//}

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


//class ApiProvider {
//    private var session: URLSession
//    private var requestProvider: RequestProvider
//    private var secureData: SecureDataProtocol
//    
//    init(session: URLSession = URLSession.shared,
//         requestProvider: RequestProvider = RequestProvider(),
//         secureData: SecureDataProtocol = SecureDataKeychain()) {
//        self.session = session
//        self.requestProvider = requestProvider
//        self.secureData = secureData
//    }
//    
//    func loginWith(email: String, password: String, completion: @escaping (( Result<Bool,DragonballError>) -> Void)) {
//        var request = requestProvider.requestFor(endpoint: .login)
//        let credentials = String(format: "%@:%@", email, password)
//        guard let data = credentials.data(using: .utf8)?.base64EncodedString() else {
//            completion(.failure(.parsingData))
//            return
//        }
//        
//        request.setValue("Basic \(data)", forHTTPHeaderField: "Authorization")
//        session.dataTask(with: request) { data, response, error in
//            //TODO: - Gestion de errores
//            
//            if let error {
//                completion(.failure(.server(error: error)))
//                return
//            }
//            
//            if let statusCode = (response as? HTTPURLResponse)?.statusCode,
//               statusCode != 200 {
//                completion(.failure(.statusCode(code: statusCode)))
//                return
//            }
//            print("Error en loginWith\(String(describing: error))")
//            if let data,
//                let token = String(data: data, encoding: .utf8) {
//                self.secureData.setToken(value: token)
//                print(token)
//                completion(.success(true))
//            } else {
//                //TODO: - gestionar
//                print("Error loginWith")
//            }
//        }.resume()
//    }
    
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
            
            //TODO: - MAnage error getting token
            guard let token = secureData.getToken() else {
                //completion(.failure(.noToken))
                print("Error Token hero")
                return
            }
            print("token: \(token)")
            //let token = secureData.getToken()!
            let request = requestProvider.requestFor(endPoint: .heroes, token: token, params: ["name": name ?? ""])
            makeDataRequestfor(request: request, completion: completion)
        }
        
        func getLocationsForHeroWith(id: String,
                                     completion: @escaping (Result<[Location], DragonballError>) -> Void) {
            //TODO: - MAnage error getting token
            guard let token = secureData.getToken() else {
                //completion(.failure(.noToken))
                print("Error Token location")
                return
            }
            print("token: \(token)")
            //let token = secureData.getToken()!
            let request = requestProvider.requestFor(endPoint: .locations, token: token, params: ["id": id])
            makeDataRequestfor(request: request, completion: completion)
        }
        
        func getTransformationsForHeroWith(id: String,
                                           completion: @escaping (Result<[Transformation], DragonballError>) -> Void) {
            //TODO: - MAnage error getting token
            guard let token = secureData.getToken() else {
                //completion(.failure(.noToken))
                print("Error Token transformation")
                return
            }
            print("token: \(token)")
            //let token = secureData.getToken()!
            let request = requestProvider.requestFor(endPoint: .transformations, token: token, params: ["id": id])
            makeDataRequestfor(request: request, completion: completion)
        }
    }
    
//    func getHeroesWith(name: String? = nil, completion: @escaping (Result<[Hero], GAFError>) -> Void) {
//        guard let token = secureData.getToken() else {
//            completion(.failure(.noToken))
//            return
//        }
//        let request = RequestProvider.requestFor(endpoint: .heroes, token: token, params: ["name": name ?? ""])
//        makeDataRequestfor(request: request, completion: completion)
//    }
//    
//    func getLocatonsForHeroWith(id: String, completion: @escaping (Result<[Location], GAFError>) -> Void) {
//        guard let token = secureData.getToken() else {
//            completion(.failure(.noToken))
//            return
//        }
//        let request = RequestProvider.requestFor(endpoint: .locations, token: token, params: ["id": id])
//        makeDataRequestfor(request: request, completion: completion)
//    }
//    
//    func getTransformationsForHeroWith(id: String, completion: @escaping (Result<[Location], GAFError>) -> Void) {
//        guard let token = secureData.getToken() else {
//            completion(.failure(.noToken))
//            return
//        }
//        let request = RequestProvider.requestFor(endpoint: .locations, token: token, params: ["id": id])
//        makeDataRequestfor(request: request, completion: completion)
//    }
//    
//    func makeDataRequestfor<T: Decodable>(request: URLRequest, completion: @escaping (Result<[T],GAFError>) -> Void) {
//        session.dataTask(with: request) { data, response, error in
//            guard error == nil else {
//                completion(.failure(.service(error: error!)))
//                return
//            }
//            
//            if let statusCode = (response as? HTTPURLResponse)?.statusCode,
//               statusCode != 200 {
//                completion(.failure(.statusCode(code: statusCode)))
//                return
//            }
//            
//            if let data {
//                do {
//                    let heroes = try JSONDecoder().decode([T].self, from: data)
//                    completion(.success(heroes))
//                }catch {
//                    completion(.failure(.parsingData(error: error)))
//                }
//                
//            } else {
//                completion(.failure(.dataNoReceived))
//            }
//            
//        }.resume()
//    }
//}

extension ApiProvider {
    
    func makeRequestfor(request: URLRequest, completion: @escaping (Result<Bool, DragonballError>) -> Void) {
        
        session.dataTask(with: request) { data, response, error in
            
            //TODO: - Manage Server Error
            
            //TODO: - MAange Status Code error
            
            if let data {
                if let token = String(data: data, encoding: .utf8) {
                    self.secureData.setToken(value: token)
                    completion(.success(true))
                } else {
                    //TODO: - Manage PArsing Data Error passing error
                }
            } else {
                //TODO: - Manage No data received error
            }
        }.resume()
    }
    
    func makeDataRequestfor<T: Decodable>(request: URLRequest, completion: @escaping (Result<[T], DragonballError>) -> Void) {
        
        session.dataTask(with: request) { data, response, error in
            print(error?.localizedDescription as Any)
            //TODO: - Manage Server Error
            
            //TODO: - MAange Status Code error
            
            if let data {
                do {
                    let dataReceived = try JSONDecoder().decode([T].self, from: data)
                    completion(.success(dataReceived))
                } catch {
                    //TODO: - Manage PArsing Data Error passing error
                   print("//TODO: - Manage PArsing Data Error passing error")
                }
            } else {
                //TODO: - Manage No data received error
                print("//TODO: - Manage No data received error")
            }
        }.resume()
    }
}

