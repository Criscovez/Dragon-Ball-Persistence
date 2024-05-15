//
//  HeroAnnotationView.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 19-04-24.
//

import Foundation
import MapKit


// E una vista que reemplaza a la vista por defecto de una annotation en el mapa
class HeroAnnotationView: MKAnnotationView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        //Indicamos el tamaño
        frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        // Indicamos oofset para quue el centro de nuestra vista coincida con la coordenada de la annotation
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        //Propiedad que indica que se debe mostrar el popup con titulo y subtítulo al selecctiona el annotation
        canShowCallout = true
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        //Creamos ujn Imageview con la imagen que queramos, la asignamos el tamaño
        // y se lo añadimos a la MKAnnotationView como subvista.
        backgroundColor = .clear
        let image = UIImage.init(named: "bola_dragon")
        let view = UIImageView.init(image: image)
        view.frame = bounds
        addSubview(view)
    }
}

