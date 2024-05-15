//
//  HeroDetailViewController.swift
//  Dragon-Ball-Persistence
//
//  Created by Cristian Contreras Velásquez on 19-04-24.
//

import UIKit
import MapKit
import CoreLocation

class HeroDetailViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var labelDescription: UILabel!
    
    @IBOutlet weak var transformationsCollectionView: UICollectionView!
    private let viewModel: HeroDetailViewModel
    
    private let locationManager = CLLocationManager()
    
    init(viewModel: HeroDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing:HeroDetailViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        mapView.delegate = self
        mapView.showsUserTrackingButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        checkLocationAuthorizationStatus()
        addObservers()
        viewModel.loadData()
        labelDescription.text = viewModel.getDescription()
        let nib = UINib(nibName: String(describing: TransformationCollectionViewCell.self), bundle: nil)
        transformationsCollectionView.register(nib, forCellWithReuseIdentifier: TransformationCollectionViewCell.reuseIdentifier)
        
        (viewModel.numberOfTransformations() == 0) ? print("No hay transformaciones") : print("Sí hay transformaciones")
    }


    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func addObservers() {
        viewModel.stateChanged = { [weak self] state in
            switch state {
            case .updated:
                self?.updateDataInterface()
            }
        }
    }
    
    private func updateDataInterface() {
        addAnnotations()
        
        //CCentra el mapa en la primera annotation
        if let annotation = mapView.annotations.first {
            print(annotation.coordinate)
            let region = MKCoordinateRegion(center: annotation.coordinate,
                                            latitudinalMeters: 100000,
                                            longitudinalMeters: 100000)
            mapView.region = region
        }
        transformationsCollectionView.reloadData()
}

    
    //Crea las annotations  a partir de las locations del Heroe
    private func addAnnotations() {
        var annotations = [HeroAnnotation]()
        let (name, id) = viewModel.heroNameAndId()
        for location in viewModel.locationsHero() {
            annotations.append(
                HeroAnnotation.init(coordinate: .init(latitude: Double(location.latitude ?? "") ?? 0.0,
                                                      longitude: Double(location.longitude ?? "") ?? 0.0),
                                    title: name,
                                    id: id,
                                    date: location.date)
            )
        }
        //Añade las annotations al mapa
        mapView.addAnnotations(annotations)
    }
    
    func checkLocationAuthorizationStatus() {
        
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            mapView.showsUserLocation = false
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }

    @IBAction func btnDetailTapped(_ sender: Any) {
        let transformationvc = TransformationController()
        
        //Podemos definir donde para al presentar el controller de forma modal.
        let sheetvc = transformationvc.sheetPresentationController
        sheetvc?.detents = [.medium(), .large()]
        
        
        //Presenta de forma modal un controller
        self.present(transformationvc, animated: true)
    }
}


extension HeroDetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let heroAnnotation = annotation as? HeroAnnotation else {
            return
        }
        debugPrint("Annotation selected of hero \(heroAnnotation.title ?? "")")
        debugPrint("Located on  \(heroAnnotation.date ?? "")")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // solo  queremos custom vire para las annotations del dheroe, la ubicación del usuario por ejemplo
        // se mostrará con el punto azul por defecto
        guard let _ = annotation as? HeroAnnotation else {
            return nil
        }

        // si no hay annotationView que reutilizar creamos una nueva
        if let annotation = mapView.dequeueReusableAnnotationView(withIdentifier: HeroAnnotationView.reuseIdentifier) {
            return annotation
        }
        return HeroAnnotationView.init(annotation: annotation, reuseIdentifier: HeroAnnotationView.reuseIdentifier)
    }
}

extension HeroDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfTransformations()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransformationCollectionViewCell.reuseIdentifier,
                                                      for: indexPath) as! TransformationCollectionViewCell
        //cell.configureWith(model: viewModel.transformationInfo(index: indexPath))
        let nameTransformation = self.viewModel.nameForTransformation(indexPath: indexPath)
        let imageTransformation = self.viewModel.imageForTransformation(indexPath: indexPath)
        (cell as TransformationCollectionViewCell).configureWith(name:  nameTransformation)
        (cell as TransformationCollectionViewCell).configureWith(image: imageTransformation)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let transformation = viewModel.transformation(index: indexPath)
        let viewModel = TransformationViewModel(transformation: transformation)
        let transformationvc = TransformationViewController(viewModel: viewModel)
        let sheet = transformationvc.sheetPresentationController
        sheet?.detents = [.medium(), .large()]
        
        self.present(transformationvc, animated: true)
        
//        let transformationvc = TransformationController()
//        
//        //Podemos definir donde para al presentar el controller de forma modal.
//        let sheetvc = transformationvc.sheetPresentationController
//        sheetvc?.detents = [.medium(), .large()]
//        
//        
//        //Presenta de forma modal un controller
//        self.present(transformationvc, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.size.width / 2, height: collectionView.bounds.size.height)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 200)
   }
}

//MARK: - Accessibility
extension HeroDetailViewController {
    
    func configureAccessibility() {
        transformationsCollectionView.accessibilityIdentifier = "hero-mapType"
    }
}

