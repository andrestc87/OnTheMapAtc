//
//  OnTheMapViewController.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 5/22/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit

class OnTheMapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
