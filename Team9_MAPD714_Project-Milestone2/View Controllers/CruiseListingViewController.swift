//
//  HomeViewController.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Anmol Sharma on 2023-11-28.
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
//  Displays the list of cruises and some details to the users 


import UIKit

class CruiseListingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchCruise: UISearchBar!
    @IBOutlet weak var cruiseListTableView: UITableView!
    
    var selectedDestinationText: String = ""
    var selectedPortText: String = ""
    
    var userId: Int?
    
    var dbManager: DatabaseManager! // DatabaseManager instance
    
    // Array to store fetched cruises
    var cruises: [Cruise] = []
    
    // To handle search functionality
    var filteredCruises: [Cruise] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setupBackground()
        
        cruiseListTableView.delegate = self
        cruiseListTableView.dataSource = self
        
        cruiseListTableView.showsVerticalScrollIndicator = false
        
        dbManager = DatabaseManager()
        
        if(isLoggedIn()){
            fetchUserId()
        }
        // Fetch data from the database
        fetchCruiseData()
    }
    
    func fetchUserId() {
        guard let userEmail = UserDefaults.standard.string(forKey: "userEmail") else {
            print("User email not found")
            return
        }

        if let fetchedUserId = dbManager.getUserId(forEmail: userEmail) {
            userId = fetchedUserId
        }
    }
    
    func setupBackground() {
            let background = UIImage(named: "bgPayment")
            
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
    
    // Fetch cruises from the database
    func fetchCruiseData() {
        cruises = dbManager.getCruises() 
        
        if !selectedDestinationText.isEmpty && selectedDestinationText != "Select Destination" {
            // Filter cruises that have the selected destination as the trip_to value
            cruises = cruises.filter { cruise in
                return cruise.tripTo == selectedDestinationText
            }
        }else if !selectedPortText.isEmpty && selectedPortText != "Select Port" {
                // Filter cruises that have the selected port in their itinerary
                cruises = cruises.filter { cruise in
                    return cruise.visitingPorts.contains { port in
                        return port.name == selectedPortText
                    }
                }
        }
                
        filteredCruises = cruises // Initially, set filteredCruises to filtered cruises
        
        if isLoggedIn() {
            guard let userId = userId else {
                print("User ID not found")
                return
            }

            for cruise in cruises {
                if let cruiseId = dbManager.getCruiseID(forCruiseName: cruise.name) {
                    cruise.isFavourite = dbManager.isCruiseInFavourites(forUserId: userId, cruiseId: cruiseId)
                } else {
                    cruise.isFavourite = false
                }
            }
        }
        
        cruiseListTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get the selected item
        let selectedCruise = filteredCruises[indexPath.row]
        let storyboard = UIStoryboard(name: "CruiseDetailsView", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CruiseDetailsViewController") as! CruiseDetailsViewController
        viewController.cruise = selectedCruise
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Setting height for the cell
        return 570.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCruises.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CruiseCell", for: indexPath) as! CruiseTableViewCell
        
        let cruise = filteredCruises[indexPath.row]
        
        cell.configure(with: cruise)
        setupCard(cell.cardView)
        
        if isLoggedIn() {
            let heartImage = cruise.isFavourite ? UIImage(named: "icon_heart_fill") : UIImage(named: "icon_heart")
            cell.heartSelected.setImage(heartImage, for: .normal)
            cell.heartSelected.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
            cell.heartSelected.tag = indexPath.row
            cell.heartSelected.isEnabled = true // Enable the favorite button
        } else {
                    // If not logged in, disable the favorite button
            cell.heartSelected.setImage(UIImage(named: "icon_heart"), for: .normal)
            cell.heartSelected.isEnabled = false // Disable the favorite button
        }
        
        return cell
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    @objc func favoriteButtonTapped(_ sender: UIButton) {
        if isLoggedIn() {
            // Your existing code for favorite button tap handling
            let selectedRowIndex = sender.tag
                
                // Toggle the isFavourite status for the selected cruise
            filteredCruises[selectedRowIndex].isFavourite.toggle()
                
                // Reload the corresponding row in the table view
            cruiseListTableView.reloadRows(at: [IndexPath(row: selectedRowIndex, section: 0)], with: .none)
                
                // Get the selected cruise
            let selectedCruise = filteredCruises[selectedRowIndex]
                
                // Toggle the favourite status for the cruise in the database
            dbManager.toggleFavouriteCruise(forUserId: userId, cruise: selectedCruise)
        } else {
            // Handle not logged in scenario, prompt user to log in or perform necessary action
            showAlertToLogIn()
        }
    }
    
    func showAlertToLogIn() {
        let alert = UIAlertController(title: "Log In Required", message: "Please log in to use this feature.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // If search bar is empty, show all cruises
        if searchText.isEmpty {
            filteredCruises = cruises
        } else {
            // Filter cruises based on the search text
            filteredCruises = cruises.filter { cruise in
                return cruise.name.lowercased().contains(searchText.lowercased())
            }
        }

        // Reload the table view
        cruiseListTableView.reloadData()
    }
    
    func setupCard(_ cardView : UIView){
        cardView.layer.cornerRadius = 12
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0).cgColor
        cardView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.25
        cardView.layer.shadowRadius = 4
        //cardView.frame = CGRect(x: cardView.frame.origin.x, y: cardView.frame.origin.y, width: cardView.frame.width, height: 500)
    }
}

