//
//  Transformation.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 10-03-24.
//

import Foundation

//struct Transformation: Decodable {
//    var id: String?
//    var info: String?
//    var name: String?
//    var photo: String?
//    var hero: Hero?
//}

struct Transformation: Decodable {
    let id: String?
    let name: String?
    let description: String?
    let photo: String?
    let hero: Hero?
}
