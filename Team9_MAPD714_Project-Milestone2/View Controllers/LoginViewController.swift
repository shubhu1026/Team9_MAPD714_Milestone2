//
//  LoginViewController.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-11-29.
//

import UIKit

class LoginViewController: UIViewController {

    let databaseManager = DatabaseManager()

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SignUpView", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "signUpVewController") as! SignUpViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func loginUser(_ sender: Any) {
        guard let email = userEmail.text, !email.isEmpty else {
            showAlert(title: "Error", message: "Please enter your email.")
            return
        }

        guard let password = userPassword.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter your password.")
            return
        }

        // Perform login authentication using the database logic
        if databaseManager.loginUser(email: email, password: password) {
            // Login successful
            handleSuccessfulLogin()
        } else {
            // Login failed
            showAlert(title: "Error", message: "Invalid email or password. Please try again.")
        }
    }
    
    func handleSuccessfulLogin() {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(userEmail.text, forKey: "userEmail")
        
        showAlert(title: "Success", message: "Logged in successfully") { [weak self] in
            guard let self = self else { return }
            // Navigate to the desired screen upon successful login
            self.navigateToCruiseList()
        }
    }

    func navigateToCruiseList() {
        let storyboard = UIStoryboard(name: "CruiseListingView", bundle: nil)
        let cruiseListViewController = storyboard.instantiateViewController(withIdentifier: "cruiseListViewController") as! CruiseListingViewController
        cruiseListViewController.loadViewIfNeeded()
        setupBackButton()
        self.navigationController?.pushViewController(cruiseListViewController, animated: true)
    }

    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    func setupBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        backButton.tintColor = UIColor.black
        self.navigationItem.backBarButtonItem = backButton
    }
}
