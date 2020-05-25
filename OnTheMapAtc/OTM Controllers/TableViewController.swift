//
//  TableViewController.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 5/22/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var locations = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentLocations()
        
    }
    
    func getStudentLocations() {
        OTMClient.getStudentLocations { (locations, error) in
            self.locations = locations ?? []
            self.tableView.reloadData()
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        //super.logOut()
    }
    
    
    @IBAction func refreshRecords(_ sender: Any) {
        //super.refreshRecords()
    }
    
    
    @IBAction func addPin(_ sender: Any) {
        //super.addPin()
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as! LocationTableViewCell
        
        let location = self.locations[indexPath.row]
        
        if let firstName = location.firstName, let lastName = location.lastName {
            cell.nameLabel.text = firstName + " " + lastName
        }
        cell.mediaUrlLabel.text = location.mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
    
}
