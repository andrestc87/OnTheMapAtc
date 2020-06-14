//
//  AddLocationViewController.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 6/7/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationTextField: LoginTextField!
    @IBOutlet weak var linkTextField: LoginTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: LoginButton!
    // to store the current active textfield
    var activeTextField : UITextField? = nil
    var locationPlaceMark: CLPlacemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationTextField.delegate = self
        self.linkTextField.delegate = self
        subscribeFromKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Disabling the camera button if is not available
        //subscribeFromKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unSubscribeFromKeyboardNotifications()
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
    
    func subscribeFromKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unSubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
        
        let editingTextFieldYPosition: CGFloat! = self.activeTextField?.frame.origin.y
        let keyboardYPosition = self.view.frame.size.height - keyboardSize.height
        
        if self.view.frame.origin.y >= 0 {
            // Checks if the active textfield is hidden when the keyboard appears
            if editingTextFieldYPosition > keyboardYPosition - 60 {
                self.view.frame.origin.y = (self.view.frame.origin.y - (editingTextFieldYPosition - (keyboardYPosition - 60)))
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
      // set the activeTextField to the selected textfield
      self.activeTextField = textField
    }
      
    func textFieldDidEndEditing(_ textField: UITextField) {
      self.activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
