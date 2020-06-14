//
//  AddLocationViewController.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 6/7/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: LoginTextField!
    @IBOutlet weak var linkTextField: LoginTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: LoginButton!
    
    var locationPlaceMark: CLPlacemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? FindLocationViewController else { return }
        destinationVC.locationPlaceMark = self.locationPlaceMark
        destinationVC.locationDescription = self.locationTextField.text
        destinationVC.studentUrl = self.linkTextField.text
    }
    
    @IBAction func navigateToFindLocation(_ sender: Any) {
        if locationTextField.text?.count == 0 || linkTextField.text?.count == 0 {
            showAlertMessage(message: "Please, insert a location and a link.")
        } else {
            self.setLoggingIn(true)
            CLGeocoder().geocodeAddressString(locationTextField.text!){ (placemark, error) in
                guard error == nil else {
                    self.setLoggingIn(false)
                    self.showAlertMessage(message: "The location was not found.")
                    return
                }
                self.locationPlaceMark = placemark?[0]
                self.performSegue(withIdentifier: "showFindLocation", sender: nil)
                self.setLoggingIn(false)
            }
        }
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
        locationTextField.isEnabled = !loggingIn
        linkTextField.isEnabled = !loggingIn
        findLocationButton.isEnabled = !loggingIn
    }
}
