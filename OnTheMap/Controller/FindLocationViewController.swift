//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by Fatimah on 16/03/1441 AH.
//  Copyright © 1441 Fatimah. All rights reserved.
//

import Foundation
import  UIKit

class FindLocationViewController: UIViewController {
    
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setIndicator(false)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func findLocationButton(_ sender: Any) {
        
        if locationTextField.text == "" || mediaURLTextField.text == "" {
            setIndicator(false)
            self.showFailure(message: "Please fill both fields")
        } else {
        setIndicator(true)
            self.performSegue(withIdentifier: "findLocationOnMap", sender: self)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addVC = segue.destination as! AddLocationViewController
        
        addVC.location = locationTextField.text
        addVC.mediaURL = mediaURLTextField.text
        
    }
    
    func setIndicator(_ searchingLocation: Bool){
        DispatchQueue.main.async {
            if searchingLocation {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func showFailure(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alert.addAction(dismissAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
