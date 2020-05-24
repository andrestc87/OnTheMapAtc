//
//  MapViewController.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 5/22/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit

class MapViewController: OnTheMapViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_ sender: Any) {
        super.logOut()
    }
    
    
    @IBAction func refreshRecords(_ sender: Any) {
        super.refreshRecords()
    }
    
    
    @IBAction func addPin(_ sender: Any) {
        super.addPin()
    }
    
}
