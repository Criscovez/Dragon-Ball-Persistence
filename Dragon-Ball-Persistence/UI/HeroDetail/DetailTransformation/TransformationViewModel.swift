//
//  TransformationViewModel.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 28-04-24.
//

import Foundation

protocol TransformationProtocol {
    func getImage() -> String?
    func getTitle() -> String
    func getDescription() -> String
}

class TransformationViewModel: TransformationProtocol {
    
    private let transformation: NSMTransformation
    
    init(transformation: NSMTransformation) {
        self.transformation = transformation
    }
    
    func getImage() -> String? {
        return transformation.photo
    }
    
    func getTitle() -> String {
        return transformation.name ?? "No name"
    }
    
    func getDescription() -> String {
        print(transformation.info!)
        return transformation.info ?? ""
    }
}
