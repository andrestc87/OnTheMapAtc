//
//  MapViewController.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 5/22/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapLogOutButton: UIBarButtonItem!
    @IBOutlet weak var addLocationButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshMapButton: UIBarButtonItem!
    
    var locations = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentLocations()
    }
    
    @IBAction func logout(_ sender: Any) {
        self.activityIndicator.startAnimating()
        OTMClient.logout { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.activityIndicator.stopAnimating()
                self.showAlertMessage(message: "An error occurred logging out.")
            }
        }
    }
    
    @IBAction func refreshRecords(_ sender: Any) {
        self.getStudentLocations()
    }
    
    @IBAction func addPin(_ sender: Any) {
        performSegue(withIdentifier: "showLocationForm", sender: nil)
    }
    
    func getStudentLocations() {
        self.activityIndicator.startAnimating()
        OTMClient.getStudentLocations(limit: 100, skip: 0) { (locations, error) in
            if error != nil {
                self.activityIndicator.stopAnimating()
                self.showAlertMessage(message: "Error loading student locations.")
            } else {
                self.locations = locations ?? []
                self.addMapPins(locations: self.locations)
            }
        }
    }
    
    func addMapPins(locations: [StudentLocation]){
        var mapPin = [MKPointAnnotation]()
        
        for location in locations {
            let longitude = CLLocationDegrees(location.longitude!)
            let latitude = CLLocationDegrees(location.latitude!)
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let mediaURL = location.mediaURL
            let studentName = "\(location.firstName ?? "") \(location.lastName ?? "")"
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = studentName
            annotation.subtitle = mediaURL
            
            mapPin.append(annotation)
        }
        
        // Get the first location to center the map on it once it is loaded
        let firstPin = mapPin.count > 0 ? mapPin[1] : nil
        
        DispatchQueue.main.async {
            self.mapView.addAnnotations(mapPin)
            if firstPin != nil {
                self.setMapRegionForItem(pin: firstPin!)
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    func setMapRegionForItem(pin: MKPointAnnotation) {
        let coordinateRegion = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func showAlertMessage(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //MapView Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationId = "annotationPin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationId)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = .blue
            pinView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            if let open = view.annotation?.subtitle {
                guard let url = URL(string: open!) else { return }
                if url.absoluteString.contains("https://") {
                    let webViewController = SFSafariViewController(url: url)
                    self.present(webViewController, animated: true, completion: nil)
                } else {
                    self.showAlertMessage(message: "The URL is not valid. Please review.")
                }
            }
        }
    }
}
