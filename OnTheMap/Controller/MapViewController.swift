//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Fatimah on 12/03/1441 AH.
//  Copyright © 1441 Fatimah. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var studentLocation: [StudentLocation]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.studentLocation
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        UdacityClient.getStudentLocations { (response, error) in
            if error != nil {
                self.showFailure(message: error?.localizedDescription ?? "")
                return
            }
            guard let response = response else {
                self.showFailure(message: "Sorry there is a problem with the data")
                return
            }
            
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.studentLocation.append(contentsOf: response.results)
           
            var annotations = [MKPointAnnotation]()
            for location in appDelegate.studentLocation {
                        
                        let lat = CLLocationDegrees(location.latitude)
                        let long = CLLocationDegrees(location.longitude)
                        
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        
                        let firstName = location.firstName
                        let lastName = location.lastName
                        let mediaURL = location.mediaURL
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(firstName) \(lastName)"
                        annotation.subtitle = mediaURL
                        
                        annotations.append(annotation)
                    }
                    self.mapView.addAnnotations(annotations)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                if let url = URL(string: toOpen) {
                   app.open(url, options: [:]) { (success) in
                       if !success {
                           self.showFailure(message: "Invalid URL")
                       }
                   }
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
}
