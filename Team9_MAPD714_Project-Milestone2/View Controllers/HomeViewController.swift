//
//  HomeViewController.swift
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
//  Submission date - 1 Dec 2023
//
// Home screen for the app

import UIKit

class CellClass: UITableViewCell {
    
}

class HomeViewController: UIViewController {
    @IBOutlet weak var callButton: UIButton!
    
    var dataSource = [String]()
    
    // outlets
    @IBOutlet weak var selectedDestination: UIButton!
    @IBOutlet weak var selectedPort: UIButton!
    @IBOutlet weak var selectedDate: UIButton!
    
    var portsForSelectedDestination: [String] = []
    
    let transparentView = UIView()
    let menuView = UIView()
    let tableView = UITableView()
    var menuItemLabels: [UILabel] = []
    var selectedButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting tables delegates and datasource
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // on call button tap
    @IBAction func callButtonTapped(_ sender: Any) {
        print("Button Tapped")
        let phoneNumber = "tel://1234567890"
           if let url = URL(string: phoneNumber) {
               if UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url, options: [:]) { success in
                       if success {
                           print("Phone call opened successfully")
                       } else {
                           print("Failed to open phone call")
                       }
                   }
               } else {
                   print("Cannot open URL")
               }
           } else {
               print("Invalid URL")
           }
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        openSideMenu()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        loginFunction()
    }
    
    // Add Logo Image in  Menu at bottom
    let menuImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo_black"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func openSideMenu(){
        let window = UIApplication.shared.keyWindow
            transparentView.frame = window?.frame ?? self.view.frame
            self.view.addSubview(transparentView)
            // White frame view
            menuView.frame =  CGRect(x: 0, y: 0, width: view.frame.width - 100, height: view.frame.height)
            menuView.backgroundColor = UIColor.white
            menuImageView.frame = CGRect(x: (menuView.frame.width - 100 )/2, y: menuView.frame.height - 100, width: 110, height: 50)
            menuView.addSubview(menuImageView)
            menuView.layer.cornerRadius = 10
            view.addSubview(menuView)
            var menuItems : [String] = []
            if isLoggedIn(){
               // User profile data is present
               menuItems = ["My Profile", "My Favourites", "Destination Deals", "About Us", "Log Out"]
           } else {
               // User profile data is not present
               menuItems = ["Login", "Sign Up", "My Favourites", "Destination Deals", "About Us"]
           }
            var yOffset: CGFloat = 60
            let menuItemHeight: CGFloat = 40  // Declare menuItemHeight here

            for menuItemText in menuItems {
                let menuItemLabel = UILabel(frame: CGRect(x: 28, y: yOffset, width: menuView.frame.width - 40, height: menuItemHeight))
                menuItemLabel.text = menuItemText
                menuItemLabel.textColor = UIColor.black
                menuItemLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .thin)
                menuView.addSubview(menuItemLabel)
                menuItemLabels.append(menuItemLabel) // Store the reference

                // Add tap gesture recognizer to each menu item
                menuItemLabel.isUserInteractionEnabled = true
                menuItemLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuItemTapped(_:))))
                yOffset += menuItemHeight
            }
        
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4 , delay: 0.0 , usingSpringWithDamping: 1.0 ,
                       initialSpringVelocity: 1.0, options : .curveEaseInOut , animations: {self.transparentView.alpha = 0.5
        },completion: nil )
        
    }
    
    func isLoggedIn() -> Bool{
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    @objc func menuItemTapped(_ gesture: UITapGestureRecognizer) {
        guard let tappedLabel = gesture.view as? UILabel else { return }

        // Identify which menu item label was tapped
        if let menuItemText = tappedLabel.text {
            // Call a function based on the tapped menu item
            switch menuItemText {
            case "Login":
                // Call a function for Login In
                loginFunction()
            case "Sign Up":
                // Call a function for Sign Up
                signUpFunction()
            case "My Profile":
                // Call a function for My Profile
                myProfileFunction()
            case "Log Out":
                logout()
            // Add cases for other menu items as needed
            default:
                break
            }
        }

        // Close the side menu or perform other actions as needed
        removeTransparentView()
    }

    func loginFunction() {
        let storyboard = UIStoryboard(name: "LoginView", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "loginView") as! LoginViewController
        self.navigationController?.pushViewController(viewController, animated: true)
        // Implement the function for Login In
        print("Login In tapped")
    }
    
    func logout() {
        // Clear user profile data from UserDefaults
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
       
        loginFunction()

        // Close the side menu
        removeTransparentView()

        print("Logout successful!")
    }

    func signUpFunction() {
        let storyboard = UIStoryboard(name: "SignUpView", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "signUpVewController") as! SignUpViewController
        self.navigationController?.pushViewController(viewController, animated: true)
        // Implement the function for Sign Up
        print("Sign Up tapped")
    }

    func myProfileFunction() {
        let storyboard = UIStoryboard(name: "ProfilePageView", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "profilePageViewController") as! ProfilePageViewController
        self.navigationController?.pushViewController(viewController, animated: true)
        // Implement the function for My Profile
        print("My Profile tapped")
    }

    func addTransparentView(frames : CGRect){
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        let convertedFrame = selectedDestination.convert(selectedDestination.bounds, to: self.view)
                
                tableView.frame = CGRect(x: convertedFrame.origin.x, y: convertedFrame.origin.y + convertedFrame.height, width: convertedFrame.width, height: 0)
                self.view.addSubview(tableView)
                tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4 , delay: 0.0 , usingSpringWithDamping: 1.0 ,
                       initialSpringVelocity: 1.0, options : .curveEaseInOut , animations: {self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: convertedFrame.origin.x, y: convertedFrame.origin.y + convertedFrame.height  , width: convertedFrame.width, height: CGFloat(self.dataSource.count * 50))
        },completion: nil )
    }
    
    @objc func removeTransparentView(){
        let frames = selectedButton.convert(selectedButton.bounds, to: self.view)

           UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
               self.transparentView.alpha = 0
               self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
               self.menuView.frame = CGRect(x: 0, y: 0, width: 0, height: self.view.frame.height)

               // Remove the menu item labels
               for label in self.menuItemLabels {
                   label.removeFromSuperview()
               }
               self.menuImageView.removeFromSuperview()
               self.menuItemLabels.removeAll()
           }, completion: { _ in
               self.transparentView.removeFromSuperview()
               self.tableView.removeFromSuperview()
           })
    }
    
    @IBAction func chooseDestination(_ sender: Any) {
        dataSource = ["United States", "Italy", "Australia","Japan","Canada" ]
        selectedButton = selectedDestination
        selectedPort.setTitle("Select Port", for: .normal)
        addTransparentView(frames : selectedDestination.frame)
    }
    
    @IBAction func choosePort(_ sender: Any) {
        if(selectedDestination.title(for: .normal) == "United States" ){
            dataSource = ["Port Miami", "Port Everglades", "Port Canaveral","Port of Galveston","Port of New Orleans","Port of Los Angeles","Port of San Diego"
                ,"Port of Seattle"
            ]
        }else if(selectedDestination.title(for: .normal) == "Italy"){
            dataSource = ["Port of Venice","Port of Genoa","Port of Naples","Port of Livorno","Port of Palermo",
            "Port of Bari","Port of Ancona","Port of Cagliari"]
        }else if(selectedDestination.title(for: .normal) == "Australia"){
            dataSource = ["Port of Sydney","Port of Melbourne","Port of Brisbane","Port of Fremantle","Port of Adelaide",
            "Port of Cairns","Port of Hobart","Port of Darwin"]
        }else if(selectedDestination.title(for: .normal) == "Japan"){
            dataSource = ["Port of Tokyo","Port of Yokohama","Port of Kobe","Port of Osaka","Port of Nagasaki",
            "Port of Fukuoka","Port of Okinawa","Port of Shimizu"]
        }else if(selectedDestination.title(for: .normal) == "Canada"){
            dataSource = ["Port of Vancouver","Canada Place","Port of Victoria","Port of Seattle"]
        }
        
        selectedButton = selectedPort
        addTransparentView(frames : selectedDestination.frame)
    }
    
    @IBAction func chooseDate(_ sender: UIButton) {
        selectedButton = selectedDate
        let datePicker = UIDatePicker()
                  datePicker.datePickerMode = .date
                  datePicker.minimumDate = Date() // Disable previous dates
                  let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        let pickerFrame = CGRect(x: 0, y: 0, width: alertController.view.bounds.size.width - 20, height: 200)
           datePicker.frame = pickerFrame
           datePicker.center = CGPoint(x: alertController.view.bounds.size.width / 6, y: datePicker.center.y)

           alertController.view.addSubview(datePicker)

                  let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
                      let selectedDate = datePicker.date
                      let dateFormatter = DateFormatter()
                      dateFormatter.dateFormat = "dd-MMM-yyyy" // You can choose a format that suits your needs
                      let selectedDateString = dateFormatter.string(from: selectedDate)
                      self.selectedButton.setTitle( selectedDateString, for: .normal)
                      self.selectedButton.layer.cornerRadius = 10
                      // Handle the selected date
                      print("Selected Date: \(selectedDate)")
                  }
                  alertController.addAction(doneAction)

                  let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                  alertController.addAction(cancelAction)

                  present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func searchCruises(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CruiseListingView", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "cruiseListViewController") as! CruiseListingViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView : UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        selectedButton.layer.cornerRadius = 10
        removeTransparentView()
    }
}
