//
//  FindLocationViewController.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 6/7/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveLocationButton: LoginButton!
    
    var locationPlaceMark: CLPlacemark!
    var locationDescription: String!
    var studentUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setPinForLocation()
    }
    
    @IBAction func saveLocation(_ sender: Any) {
        self.setLoggingIn(true)
        OTMClient.getStudentData { (succes, error) in
            // The uniqueKey, firstName and lastName are already set on OTMClient.Auth object
            // Now we add the other values so we have all the parameters needed
            OTMClient.Auth.mediaUrl = self.studentUrl
            OTMClient.Auth.mapString = self.locationDescription
            OTMClient.Auth.latitude = self.locationPlaceMark!.location!.coordinate.latitude
            OTMClient.Auth.longitude = self.locationPlaceMark!.location!.coordinate.longitude
            
            if succes {
                // Verify if the object ID is empty, if it is post if not put
                if OTMClient.Auth.objectid.count == 0 {
                    self.saveStudentLocation()
                } else {
                    self.updateStudenLocation()
                }
            } else {
                self.showAlertMessage(message: "The Student Data was not found.")
                self.setLoggingIn(false)
            }
        }
    }
    
    func saveStudentLocation() {
        OTMClient.saveStudentLocation { (success, error) in
            if success {
                self.setLoggingIn(false)
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.setLoggingIn(false)
                OTMClient.Auth.objectid = ""
                self.showAlertMessage(message: "Error saving the student location. Please try again")
            }
        }
    }
    
    func updateStudenLocation() {
        OTMClient.updateStudentLocation { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.setLoggingIn(false)
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.setLoggingIn(false)
                self.showAlertMessage(message: "Error upating the student location. Please try again.")
            }
        }
    }
    
    func setPinForLocation() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.locationPlaceMark!.location!.coordinate
        annotation.title = self.locationDescription
        
        let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        self.mapView.addAnnotation(annotation)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //MapView Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationId = "annotationPin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationId)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = .blue
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        mapView.selectAnnotation(mapView.annotations[0], animated: true)
    }
    
    func showAlertMessage(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        saveLocationButton.isEnabled = !loggingIn
    }
}
