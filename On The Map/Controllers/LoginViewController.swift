//
//  LoginViewController.swift
//  On The Map
//
//  Created by Asma  on 1/11/21.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    let segueIdentifier="showTabVC"
    let signUpSegue="signUpSegue"
    

    @IBAction func loginTap(_ sender: Any) {
        loggingIn(true)
        UdacityClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpTap(_ sender: Any) {
        
        performSegue(withIdentifier: signUpSegue, sender: nil)
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            performSegue(withIdentifier: segueIdentifier, sender: nil)
            loggingIn(false)
        } else {
            showAlert(kind: .show, title: "Login Failed", message: error?.localizedDescription ?? "", action: "OK")
            loggingIn(false)
        }
    }
    
    func loggingIn(_ loggingIn:Bool){
        if(loggingIn){
            activityIndicator.startAnimating()
        }else{
            activityIndicator.stopAnimating()
        }
        
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        signUpButton.isEnabled = !loggingIn
        
    }   
    
}

