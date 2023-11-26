//
//  RegisterViewController.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-10-30.
//
//  Team Number: 9
//  Milestone Number: 2
//
//  Team Members:
//  Shubham Patel - 301366205
//  Anmol Sharma - 301364872
//  Submission date - 30 Oct 2023
//
//  The file will handle user registration logic and further navigation code

import UIKit

class RegisterViewController: UIViewController {
    
    let databaseManager = DatabaseManager()

    @IBOutlet var registerTitle: UILabel!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var cardView: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.isModalInPresentation = true
    }
    
    func setupUI() {
        setupCardView()
        setupBackground()
        setupButton()
    }
    
    // setup card
    func setupCardView()
    {
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 2
        cardView.layer.masksToBounds = false
        
        registerTitle.textColor = UIColor.white
    }
    
    // changing background image
    func setupBackground() {
        let background = UIImage(named: "bgLoginRegister")
        
        var imageView: UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        self.view.sendSubviewToBack(imageView)
    }
    
    // changing button css
    func setupButton()
    {
        let customColor = UIColor(red: 5/255, green: 29/255, blue: 31/255, alpha: 0.7)
        registerButton.tintColor = customColor
        registerButton.layer.shadowColor = UIColor.black.cgColor
        registerButton.layer.shadowOffset = CGSize(width: 4, height: 8)
        registerButton.layer.shadowRadius = 4
        registerButton.layer.shadowOpacity = 0.25
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
                showAlert(with: "Error", message: "All fields are required")
                return
        }

        guard password == confirmPassword else {
            showAlert(with: "Error", message: "Passwords do not match")
            return
        }
                
        guard !databaseManager.doesEmailExist(email: email) else {
            showAlert(with: "Error", message: "Email already exists. Please use a different email.")
            return
        }
                
        let name = "Name"
        let address = "Address"
        let city = "City"
        let country = "Country"
                
        if databaseManager.registerUser(name: name, email: email, password: password, address: address, city: city, country: country) {
                handleSuccessfulRegistration()
            } else {
                showAlert(with: "Error", message: "Registration failed. Please try again.")
        }
    }
            
    func handleSuccessfulRegistration() {
        showAlert(with: "Success", message: "User registered successfully") { [weak self] in
            guard let self = self else { return }
            self.navigateToCruiseList()
        }
    }
            
    func navigateToCruiseList() {
        let cruiseListViewController = self.storyboard!.instantiateViewController(withIdentifier: "CruiseListViewController") as! CruiseListViewController
        cruiseListViewController.loadViewIfNeeded()
        setupBackButton()
        self.navigationController?.pushViewController(cruiseListViewController, animated: true)
    }
            
    func showAlert(with title: String, message: String, completion: (() -> Void)? = nil) {
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
