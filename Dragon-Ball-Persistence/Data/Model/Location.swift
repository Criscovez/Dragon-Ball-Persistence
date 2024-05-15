//
//  Location.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 10-03-24.
//

import Foundation

struct Location: Decodable {
    var id: String?
    var date: String?
    var latitude: String?
    var longitude: String?
    var hero: Hero?
    
    enum CodingKeys: String, CodingKey {
        case id
        case latitude = "latitud"
        case longitude = "longitud"
        case date = "dateShow"
        case hero
    }
}
