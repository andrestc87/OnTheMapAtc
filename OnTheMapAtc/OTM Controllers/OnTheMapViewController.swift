//
//  OnTheMapViewController.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 5/22/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit

class OnTheMapViewController: UIViewController {
    
    var studentLocations = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentLocations()
        
    }
    
    func getStudentLocations() {
        OTMClient.getStudentLocations { (locations, error) in
            self.studentLocations = locations ?? []
        }
    }
    
    func logOut() {
        
        print("LOGOUT")
        dismiss(animated: true, completion: nil)
        
    }
    
    func refreshRecords() {
        
        print("REFRESH RECORDS")
        
    }
    
    func addPin() {
        
        print("ADD PIN")
        
    }
    
}
