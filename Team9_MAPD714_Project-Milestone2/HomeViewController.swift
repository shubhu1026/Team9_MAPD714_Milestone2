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

class HomeViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate {
    
    var temp = 1
    var tapGesture: UITapGestureRecognizer?
    @IBOutlet weak var selectDestinationDropdown: UITextField!
    @IBOutlet weak var selectDestinationDropdownView: UIPickerView!
    @IBOutlet weak var selectPortDropdown: UITextField!
    @IBOutlet weak var selectPortDropdownView: UIPickerView!

    @IBOutlet weak var selectDatePicker: UITextField!
    @IBOutlet weak var selectDatePickerView: UIDatePicker!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    var list = ["Spain", "Australia", "United Kingdom", "Japan"]
    var listPort = ["Miami", "Sydney", "london", "Tokyo"]
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(temp == 1){
            return list.count
        }else{
            return listPort.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           self.view.endEditing(true)
        if(temp == 1){
            return list[row]
        }else{
            return listPort[row]
        }
         
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(temp == 1){
            self.selectDestinationDropdown.text = self.list[row]
            self.selectDestinationDropdownView.isHidden = true
        }else{
            self.selectPortDropdown.text = self.listPort[row]
            self.selectPortDropdownView.isHidden = true
        }
       
    }
    
    @IBOutlet var cardView: UIView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var searchButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        selectDestinationDropdownView.delegate = self
        selectDestinationDropdownView.dataSource = self
        selectPortDropdownView.delegate = self
        // Hide the dropdown picker initially
        selectPortDropdownView.dataSource = self
        selectPortDropdownView.isHidden = true
        selectDestinationDropdownView.isHidden = true
         // Configure the date picker only for the selectDatePicker text field
        selectDatePickerView.isHidden = true
        selectDatePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)

        // Initialize the tap gesture recognizer to handle taps outside text fields
        if tapGesture == nil {
                    tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                }
                if let tapGesture = tapGesture {
                    view.addGestureRecognizer(tapGesture)
                }
        // Do any additional setup after loading the view.
        setupBackground()
        
        setupCardView()
        
        setupButton()
    }
    
    @IBAction func SelectDestinationDidBeginEditing(_ sender: UITextField) {
        temp = 1
        selectDestinationDropdownView.isHidden = false
    }
    @IBAction func SelectPortDidBeginEditing(_ sender: UITextField) {
        temp = 2
        selectPortDropdownView.isHidden = false
    }
    @IBAction func SelectDateDidBeginEditing(_ sender: UITextField) {
        if sender == selectDatePicker {
                   temp = 3
            selectDatePickerView.isHidden = false // Show the date picker only for the selectDatePicker text field
        }
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
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
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
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
     // Hide the date picker and resign first responder status from all text fields
        selectDatePickerView.isHidden = true
        selectDestinationDropdown.resignFirstResponder()
        selectPortDropdown.resignFirstResponder()
        selectDatePicker.resignFirstResponder()
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
    @objc func datePickerValueChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        selectDatePicker.text = dateFormatter.string(from: selectDatePickerView.date)
    }
    

    @IBAction func searchButtonClicked(_ sender: Any) {
        let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        loginViewController.loadViewIfNeeded()
            //self.present(loginViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
}


