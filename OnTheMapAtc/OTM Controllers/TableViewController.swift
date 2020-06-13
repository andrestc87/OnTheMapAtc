//
//  TableViewController.swift
//  OnTheMapAtc
//
//  Created by andres tello campos on 5/22/20.
//  Copyright © 2020 andres tello campos. All rights reserved.
//

import UIKit
import SafariServices

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var locations = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentLocations()
        
    }
    
    func getStudentLocations() {
        OTMClient.getStudentLocations(limit: 100, skip: 0) { (locations, error) in
            self.locations = locations ?? []
            self.tableView.reloadData()
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        OTMClient.logout { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.showAlertMessage(message: "An error occurred logging out.")
            }
        }
    }
    
    @IBAction func refreshTable(_ sender: Any) {
        self.getStudentLocations()
    }
    
    
    @IBAction func addPin(_ sender: Any) {
        performSegue(withIdentifier: "showLocationForm", sender: nil)
    }
    
    func showAlertMessage(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertVC, animated: true, completion: nil)
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
        
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        
        return cell
    }
    
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = self.locations[indexPath.row]
        if let mediaUrl = location.mediaURL {
            guard let url = URL(string: mediaUrl) else { return }
            if url.absoluteString.contains("https://") {
                let webViewController = SFSafariViewController(url: url)
                self.present(webViewController, animated: true, completion: nil)
            } else {
                self.showAlertMessage(message: "The URL is not valid. Please review.")
            }
        } else {
            self.showAlertMessage(message: "The selected student have not set a url.")
        }
    }
}
