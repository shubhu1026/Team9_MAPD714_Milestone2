import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userConfirmPassword: UITextField!

    let databaseManager = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.isModalInPresentation = true
    }
    
    func setupUI() {
        // Setup UI elements if needed
    }

    @IBAction func signUpUser(_ sender: Any) {
        // Your existing sign-up logic with user input validation
        guard let email = userEmail.text, !email.isEmpty, isValidEmail(email: email) else {
            showAlert(message: "Please enter a valid email.")
            return
        }

        guard let password = userPassword.text, !password.isEmpty, password.count >= 6 else {
            showAlert(message: "Password must be at least 6 characters long.")
            return
        }

        guard let confirmPassword = userConfirmPassword.text, !confirmPassword.isEmpty, confirmPassword == password else {
            showAlert(message: "Passwords do not match.")
            return
        }

        // Check if email exists in the database
        guard !databaseManager.doesEmailExist(email: email) else {
            showAlert(message: "Email already exists. Please use a different email.")
            return
        }

        // Register the user using the database manager
        let name = "Name"
        let address = "Address"
        let city = "City"
        let country = "Country"
        let phoneNumber = "Number"
        
        if databaseManager.registerUser(name: name, email: email, password: password, address: address, city: city, country: country, phoneNumber: phoneNumber) {
            handleSuccessfulRegistration()
        } else {
            showAlert(message: "Registration failed. Please try again.")
        }
    }
    
    private func handleSuccessfulRegistration() {
        showAlert(message: "User registered successfully") {
            if let email = self.userEmail.text {
                        self.navigateToProfilePage(with: email)
                }
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Handle OK action if needed
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }


    private func showAlert(message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    private func navigateToProfilePage(with email: String) {
        let storyboard = UIStoryboard(name: "ProfilePageView", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "profilePageViewController") as! ProfilePageViewController
        viewController.userEmailText = email 
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    private func isValidEmail(email: String) -> Bool {
        // Your email validation logic
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
