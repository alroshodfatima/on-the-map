//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Fatimah on 13/03/1441 AH.
//  Copyright © 1441 Fatimah. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
