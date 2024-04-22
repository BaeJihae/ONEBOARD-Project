//
//  MapViewController.swift
//  OneBoardProject
//
//  Created by CaliaPark on 4/22/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var kickboardList = [
            Kickboard(kickBoardID: "Pro", kickBoardNumber: 101, kickBoardLocation: (37.5023, 127.0451), kickBoardStatus: false, pricePerMinute: 180),
            Kickboard(kickBoardID: "Pro", kickBoardNumber: 102, kickBoardLocation: (37.5023, 127.0441), kickBoardStatus: false, pricePerMinute: 180),
            Kickboard(kickBoardID: "Pro", kickBoardNumber: 103, kickBoardLocation: (37.5024, 127.0455), kickBoardStatus: false, pricePerMinute: 180),
            Kickboard(kickBoardID: "Pro", kickBoardNumber: 104, kickBoardLocation: (37.5025, 127.0448), kickBoardStatus: false, pricePerMinute: 180),
            Kickboard(kickBoardID: "Basic", kickBoardNumber: 105, kickBoardLocation: (37.5026, 127.0441), kickBoardStatus: false, pricePerMinute: 150),
            Kickboard(kickBoardID: "Basic", kickBoardNumber: 106, kickBoardLocation: (37.5027, 127.0443), kickBoardStatus: false, pricePerMinute: 150),
            Kickboard(kickBoardID: "Basic", kickBoardNumber: 107, kickBoardLocation: (37.5028, 127.0451), kickBoardStatus: false, pricePerMinute: 150)
            ]
    
    var mapView: MKMapView!
    let manager = CLLocationManager()
    
    var myLocationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "myLocation"), for: .normal)
        button.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var myProfileButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "myProfile"), for: .normal)
        button.addTarget(self, action: #selector(myProfileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    lazy var buttonStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [myLocationButton, myProfileButton])
        stview.axis = .vertical
        stview.distribution = .fillEqually
        stview.alignment = .fill
        return stview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupButton()
    }
    
    func setupMapView() {
        mapView = MKMapView(frame: self.view.bounds)
        self.view.addSubview(mapView)
        
        mapView.preferredConfiguration = MKStandardMapConfiguration()
        self.manager.requestWhenInUseAuthorization()
        self.mapView.delegate = self
        
        let center = CLLocationCoordinate2D(latitude: 37.5024, longitude: 127.0445)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        mapView.setRegion(region, animated: true)
        createAnnotaion()
    }
    
    func createAnnotaion() {
        var annotations: [MKAnnotation] = []
        for i in 0..<kickboardList.count {
            annotations.append(CustomAnnotation(title: kickboardList[i].kickBoardID, subtitle: String(kickboardList[i].kickBoardNumber), coordinate: CLLocationCoordinate2D(latitude: kickboardList[i].kickBoardLocation.0, longitude: kickboardList[i].kickBoardLocation.1)))
        }
        mapView.addAnnotations(annotations)
    }
    
    func setupButton() {
        view.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ])
    }
    
    @objc func myProfileButtonTapped() {
        
    }
    
    @objc func myLocationButtonTapped() {
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "Custom"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "location")
            
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        }
        return annotationView
    }
}

class CustomAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
       
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
