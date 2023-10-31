//
//  HomeViewController.swift
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
//  The current file contains code to setup card view, background, button and also the button to navigate to login/ Register screen
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var cardView: UIView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var searchButton: UIButton!
    
    let dropdownField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Select an option"
        return textField
    }()

    let pickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropdownField.inputView = pickerView
        
        // Do any additional setup after loading the view.
        setupBackground()
        
        setupCardView()
        
        setupButton()
    }
    
    func setupBackground() {
        let background = UIImage(named: "bgHome")
        
        var imageView: UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
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
        
        titleLabel.textColor = UIColor.white
    }
    
    func setupButton()
    {
        let customColor = UIColor(red: 5/255, green: 29/255, blue: 31/255, alpha: 0.7)
        searchButton.tintColor = customColor
        
        searchButton.layer.shadowColor = UIColor.black.cgColor
        searchButton.layer.shadowOffset = CGSize(width: 4, height: 8)
        searchButton.layer.shadowRadius = 4
        searchButton.layer.shadowOpacity = 0.25
    }
    

    @IBAction func searchButtonClicked(_ sender: Any) {
        let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        loginViewController.loadViewIfNeeded()
            //self.present(loginViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
}


