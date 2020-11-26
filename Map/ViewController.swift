//
//  ViewController.swift
//  Map
//
//  Created by Hovo on 8/4/20.
//  Copyright © 2020 Hovo. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController {
    @IBOutlet weak var textF: UITextField!
    var geocoder : CLGeocoder!
    let locationMeneger = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationMeneger.startUpdatingLocation()
        geocoder = CLGeocoder()
        textF.addTarget(self, action: #selector(textFieldDidChange) , for: .editingChanged)
    }
    @objc func textFieldDidChange(){
        geocoder.geocodeAddressString((textF.text!)) { (placemark, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            if placemark != nil {
                if let placemark = placemark?.first{
                    let annotation = MKPointAnnotation()
                    annotation.title = ""
                    annotation.subtitle = self.textF.text
                    annotation.coordinate = placemark.location!.coordinate
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                    
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationEnabled()
    }
    func checkLocationEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            setupManager()
            checkAuthorization()
        }else{
            showAlert(title: "У вас выключена служба геолокации", message:"Хотите включить", url: URL(string: "App-Prefs:root=LOCATION_SERVICES") )
        }
    }
    func setupManager() {
        locationMeneger.delegate = self
        locationMeneger.desiredAccuracy = kCLLocationAccuracyBest
    }
    func checkAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationMeneger.startUpdatingLocation()
        case .denied:
            showAlert(title: "Вы запретили исползование местоположения", message: "Хотите ето изменить ?" , url: URL(string: UIApplication.openSettingsURLString))
        case .restricted:
            break
        case .notDetermined:
            locationMeneger.requestWhenInUseAuthorization()
        }
        
    }
    func showAlert(title: String, message: String?, url: URL? ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (alert) in
            if let url = url{
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapView.setRegion(region, animated: true)
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }
}

