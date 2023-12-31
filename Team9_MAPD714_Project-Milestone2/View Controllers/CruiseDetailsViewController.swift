//
//  CruiseDetailsViewController.swift
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
// The file will handle the logic to populate the views with details about the cruise

import UIKit

class CruiseDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var cruise: Cruise?
    
    let dbManager = DatabaseManager()
    
    @IBOutlet weak var cruiseDetailsItineraryTableView: UITableView!
    
    @IBOutlet weak var cruiseName: UILabel!
    @IBOutlet weak var bookButton: UIButton!
    
    var itinerary: [PortInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cruiseDetailsItineraryTableView.delegate = self
        cruiseDetailsItineraryTableView.dataSource = self
        
        setupBackground()
        if let cruise = cruise {
            cruiseName.text = cruise.name
            
            itinerary = cruise.visitingPorts
        }
        setupButton()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected item
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           // Set the desired height for the cell
           return 100.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itinerary.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CruiseDetailsItineraryCell", for: indexPath) as! CruiseDetailsItineraryTableViewCell
        // Add a separator inset to the cell
        let portInfo = itinerary[indexPath.row]
        cell.setupCruiseDetailsItineraryCell(portInfo: portInfo)
    
        return cell
    }
        
    func setupBackground() {
        let background = UIImage(named: "bgShip")
        
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
    
    func setupButton()
    {
        let customColor = UIColor(red: 5/255, green: 29/255, blue: 31/255, alpha: 0.7)
        bookButton.tintColor = customColor
        
        bookButton.layer.shadowColor = UIColor.black.cgColor
        bookButton.layer.shadowOffset = CGSize(width: 4, height: 8)
        bookButton.layer.shadowRadius = 4
        bookButton.layer.shadowOpacity = 0.25
    }
    
    func setupBackButton()
        {
            let backButton = UIBarButtonItem()
            backButton.title = "Back"
            backButton.tintColor = UIColor.black

            // Set the custom back button for this view controller
            self.navigationItem.backBarButtonItem = backButton
    }
    
    @IBAction func bookButtonClicked(_ sender: Any) {
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
           
           if isLoggedIn {
               // User is logged in, proceed to the GuestDetailsViewController
               
               let storyboard = UIStoryboard(name: "GuestDetailsView", bundle: nil)
               let viewController = storyboard.instantiateViewController(withIdentifier: "GuestDetailsViewController") as! GuestDetailsViewController
               viewController.selectedCruise = cruise
               viewController.loadViewIfNeeded()
               setupBackButton()
               self.navigationController?.pushViewController(viewController, animated: true)
           } else {
               // User is not logged in, navigate to the LoginViewController
               
               let storyboard = UIStoryboard(name: "LoginView", bundle: nil)
               let viewController = storyboard.instantiateViewController(withIdentifier: "loginView") as! LoginViewController
               viewController.modalPresentationStyle = .fullScreen
               self.navigationController?.pushViewController(viewController, animated: true)
           }
    }
}
