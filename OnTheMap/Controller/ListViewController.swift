//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Fatimah on 17/03/1441 AH.
//  Copyright © 1441 Fatimah. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: override functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        UdacityClient.getStudentLocations { (success, error) in
            if error != nil {
                self.showFailure(message: error?.localizedDescription ?? "")
                return
            }
        }
    }
    
    // MARK: Custom functions
    func showFailure(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alert.addAction(dismissAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: override tableView functions
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "LocationCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        
        let location = StudentLocationData.sharedInstance.studentLocation[indexPath.row]
        
        cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
        cell.detailTextLabel?.text = location.mediaURL
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationData.sharedInstance.studentLocation.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = StudentLocationData.sharedInstance.studentLocation[indexPath.row]
        
        let app = UIApplication.shared
        if let url = URL(string: location.mediaURL) {
            app.open(url, options: [:]) { (success) in
                if !success {
                    self.showFailure(message: "Invalid URL")
                }
            }
        }
    }
}
