//
//  LoginViewController.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-10-30.
//
//
//  Team Number: 9
//  Milestone Number: 2
//
//  Team Members:
//  Shubham Patel - 301366205
//  Anmol Sharma - 301364872
//  Submission date - 30 Oct 2023
//
//  The file will handle the user login process and navigation to further screens

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var loginTitle: UILabel!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var cardView: UIView!
    
    //@IBOutlet var 
    
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
        
        loginTitle.textColor = UIColor.white
        
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
        loginButton.tintColor = customColor
        
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOffset = CGSize(width: 4, height: 8)
        loginButton.layer.shadowRadius = 4
        loginButton.layer.shadowOpacity = 0.25
    }
    
    @IBAction func signupButtonClicked(_ sender: Any){
        let registerViewController = self.storyboard!.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        
        registerViewController.loadViewIfNeeded()
        //self.present(registerViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        let storedEmail = UserDefaults.standard.object(forKey: "email")
        let storedPassword = UserDefaults.standard.object(forKey: "password")
        
        
        
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
