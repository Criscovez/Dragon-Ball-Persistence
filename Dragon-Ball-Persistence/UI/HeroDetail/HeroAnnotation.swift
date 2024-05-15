//
//  HeroAnnotation.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 19-04-24.
//

import Foundation
import MapKit


//LAs annotation deben implemntar el protocol MKAnnotation y heredar de NSOBject
//Tien una propiedad obligatoria coordinate que las coordenada, además tiene 2 propiedades opcionales
//title  y subtitle que se mostraran en el callout de la MAkAnnotationView si creamos una
//Por otro lado podemos añadir nuestras propiedades las que nos hagan falta para identificar
// la annotation pulsada en el evento del delegate de MKMapview
class HeroAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var id: String?
    var date: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String? = nil, id: String? = nil, date: String? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.id = id
        self.date = date
    }
}
