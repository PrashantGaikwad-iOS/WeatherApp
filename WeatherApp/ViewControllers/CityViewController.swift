//
//  CityViewController.swift
//  WeatherApp
//
//  Created by Prashant Gaikwad on 03/07/21.
//

import UIKit
import CoreLocation
import MapKit

class CityViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - Properties
    let locationManager = CLLocationManager()
    var selectedCoordinate:CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLocation()
        self.view.bringSubviewToFront(closeButton)

        self.view.bringSubviewToFront(self.currentLocationButton)
        
        let longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addPin(longGesture:)))
        map.addGestureRecognizer(longGestureRecognizer)
    }
    
    // MARK: - IBActions
    @IBAction func getCurrentLocation(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        map.showsUserLocation = true
        locationManager.startUpdatingLocation()
    }
    
    func showActionSheet(){
        let alert = UIAlertController(title: "Weather App", message: "Please select an option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Weather information", style: .default , handler: { (UIAlertAction) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "WeatherInfoViewController") as? WeatherInfoViewController else{return}
            vc.modalPresentationStyle = .fullScreen
            vc.location = self.selectedCoordinate
            self.present(vc, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
        }))
        
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: {
            print("inside completion block")
        })
    }
    
    @objc func addPin(longGesture: UIGestureRecognizer) {
        let touchPoint = longGesture.location(in: map)
        let newCoordinates = map.convert(touchPoint, toCoordinateFrom: map)
        self.selectedCoordinate = newCoordinates
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        let annotations = map.annotations.filter({ !($0 is MKUserLocation) })
        map.removeAnnotations(annotations)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        map.addAnnotation(annotation)
        self.showActionSheet()
    }
}

extension CityViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.selectedCoordinate = location.coordinate
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.map.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
        }
    }
}
