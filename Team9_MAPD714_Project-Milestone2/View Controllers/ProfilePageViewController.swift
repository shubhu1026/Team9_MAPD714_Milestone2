//
//  ProfilePageViewController.swift
//  IOS_Design_Practice
//
//  Created by Anmol Sharma on 2023-11-27.
//

import UIKit

class ProfilePageViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userAddress: UITextField!
    @IBOutlet weak var userCity: UITextField!
    @IBOutlet weak var userCountry: UITextField!
    @IBOutlet weak var userPhoneNumber: UITextField!
    
    var userEmailText: String?
    var user: User?
    
    let dbManager = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isLoggedIn() {
            // User is logged in, fetch details from database
            fetchUserDetailsFromDatabase()
            userEmail.isEnabled = false
        } else if let userEmailText = userEmailText,!userEmailText.isEmpty {
            // User is not logged in, but coming from registration
            userEmail.text = userEmailText
            userEmail.isEnabled = false
        }
    }
    
    func isLoggedIn() -> Bool{
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func fetchUserDetailsFromDatabase() {
        guard let email = userEmailText else { return }
        user = dbManager.getUserInfo(email: email)
        populateFields()
    }
    
    @IBAction func saveUserProfile(_ sender: Any) {
        guard let userName = userName.text, !userName.isEmpty else {
            showAlert(message: "Please enter your name.")
            return
        }

        guard let userEmail = userEmail.text, !userEmail.isEmpty, isValidEmail(email: userEmail) else {
            showAlert(message: "Please enter a valid email.")
            return
        }

        // Save user data in the database
        let updatedUser = User(userName: userName,
                               userEmail: userEmail,
                               userAddress: userAddress.text ?? "",
                               userCity: userCity.text ?? "",
                               userCountry: userCountry.text ?? "",
                               userPhoneNumber: userPhoneNumber.text ?? "")
                
        if dbManager.saveUserInfo(user: updatedUser) {
            // Optionally, navigate to another screen or perform additional actions upon successful save
            print("Profile saved successfully!")
        } else {
            showAlert(message: "Failed to save profile.")
        }
    }
    
    private func populateFields() {
        guard let user = user else { return }

        userName.text = user.userName
        userEmail.text = user.userEmail
        userAddress.text = user.userAddress
        userCity.text = user.userCity
        userCountry.text = user.userCountry
        userPhoneNumber.text = user.userPhoneNumber
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    // Helper function to validate email format
    private func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
