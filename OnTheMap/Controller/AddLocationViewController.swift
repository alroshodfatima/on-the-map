//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Fatimah on 16/03/1441 AH.
//  Copyright © 1441 Fatimah. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    // MARK: Outlets, variables, and Constants
    var location: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    var objectId: String?
    
    let geocoder: CLGeocoder = CLGeocoder()
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Override functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        findOnMap(location: location ?? "")
    }
    
    // MARK: Custom functions
    func findOnMap(location: String) {
        geocoder.geocodeAddressString(location) { placemarks, error in
            if error != nil {
                self.showFailure(message: "Sorry, couldn't find the specified location.")
                return
            }
            if let placemark = placemarks?[0] {
                let coordinates = placemark.location?.coordinate
                
                self.latitude = coordinates?.latitude
                self.longitude = coordinates?.longitude
                
                let region = MKCoordinateRegion(center: coordinates!, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates!
                self.mapView.addAnnotation(annotation)
                
                DispatchQueue.main.async{
                    self.mapView.alpha = 1.0
                    self.mapView.setRegion(region, animated: true)
                }
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
    
    // MARK: Actions
    @IBAction func submitButtonPressed(_ sender: Any) {
        UdacityClient.addingStudentLocation(longitude: longitude ?? 0.0, latitude: latitude ?? 0.0, location: location ?? "", mediaURL: mediaURL ?? "") { (studentLocation, error) in
            if error != nil {
                self.showFailure(message: error?.localizedDescription ?? "")
                return
            }
            guard let studentLocation = studentLocation else {
                self.showFailure(message: "Sorry there is a problem with the data")
                return
            }
            StudentLocationData.sharedInstance.studentLocation.append(studentLocation)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
