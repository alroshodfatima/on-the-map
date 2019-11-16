//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Fatimah on 09/03/1441 AH.
//  Copyright © 1441 Fatimah. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.text = ""
    }


    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        UdacityClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completionHandler: self.handleLoginResponse(success:error:))
    }
    
    func handleLoginResponse(success: Bool, error: Error?){

        setLoggingIn(false)
        if success{
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
        
        
        
    }
    
    func setLoggingIn(_ loggingIn: Bool){
        DispatchQueue.main.async {
            if loggingIn {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
            self.emailTextField.isEnabled = !loggingIn
            self.passwordTextField.isEnabled = !loggingIn
            self.loginButton.isEnabled = !loggingIn
        }
    }
    
    func showLoginFailure(message: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.show(alertVC, sender: nil)
        }
    }
    
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        let app = UIApplication.shared
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup") {
            app.open(url, options: [:], completionHandler: nil)
        } else {
            print("Error opening udacity URL")
        }
    }
    
    
}

