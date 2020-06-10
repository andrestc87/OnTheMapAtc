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
    
    var locationPlaceMark: CLPlacemark!
    var locationDescription: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setPinForLocation()
    }
    
    @IBAction func saveLocation(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        OTMClient.getUserData { (data, error) in
            print("GETTING USER DATA")
            print(OTMClient.Auth.firstName)
            print(OTMClient.Auth.lastName)
            print(OTMClient.Auth.uniqueKey)
            
            // Verify if the object ID is empty, if it is post if not put
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
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        mapView.selectAnnotation(mapView.annotations[0], animated: true)
    }
}
