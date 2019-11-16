//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Fatimah on 09/03/1441 AH.
//  Copyright © 1441 Fatimah. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: text field delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    // MARK: Actions
    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        UdacityClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completionHandler: handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        let app = UIApplication.shared
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup") {
            app.open(url, options: [:], completionHandler: nil)
        } else {
            print("Error opening udacity URL")
        }
    }
    
    // MARK: Custom functions
    func handleLoginResponse(success: Bool, error: Error?){
        
        setLoggingIn(false)
        if success{
            performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
        
    }
    
    func setLoggingIn(_ loggingIn: Bool){
        DispatchQueue.main.async {
            loggingIn ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
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
}

