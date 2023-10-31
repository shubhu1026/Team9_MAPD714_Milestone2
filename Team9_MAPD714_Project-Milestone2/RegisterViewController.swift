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

    @IBOutlet var registerTitle: UILabel!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var cardView: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()
        setupCardView()
        // Do any additional setup after loading the view.
        self.isModalInPresentation = true
    }
    
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
        
        setupButton()
    }
    
    func setupBackground() {
        let background = UIImage(named: "bgLoginRegister")
        
        var imageView: UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }

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
        if(passwordTextField.text == confirmPasswordTextField.text)
        {
            UserDefaults.standard.set(emailTextField.text!, forKey: "email")
            UserDefaults.standard.set(passwordTextField.text!, forKey: "password")
        }
        
        
        let cruiseListViewController = self.storyboard!.instantiateViewController(withIdentifier: "CruiseListViewController") as! CruiseListViewController
        
        cruiseListViewController.loadViewIfNeeded()
        
        setupBackButton()
        
        self.navigationController?.pushViewController(cruiseListViewController, animated: true)
    }
    
    func setupBackButton()
    {
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        backButton.tintColor = UIColor.black

        // Set the custom back button for this view controller
        self.navigationItem.backBarButtonItem = backButton
    }
}
