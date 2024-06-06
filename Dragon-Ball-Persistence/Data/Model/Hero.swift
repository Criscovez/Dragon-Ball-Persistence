//
//  Hero.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 10-03-24.
//

import Foundation

struct Hero: Decodable {
    var id: String?
    var name: String?
    var description: String?
    var photo: String?
    var favorite: Bool?

}
