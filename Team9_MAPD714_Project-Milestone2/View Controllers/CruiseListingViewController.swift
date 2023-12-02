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
        
        // Fetch data from the database
        fetchCruiseData()
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
        cruises = dbManager.getCruises() // Use DatabaseManager method to get cruises
        filteredCruises = cruises // Initially, set filteredCruises to all cruises
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
        
        let heartImage = cruise.isFavourite ? UIImage(named: "icon_heart_fill") : UIImage(named: "icon_heart")
        cell.heartSelected.setImage(heartImage, for: .normal)
        
        cell.heartSelected.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
        cell.heartSelected.tag = indexPath.row
        
        return cell
    }
    
    @objc func favoriteButtonTapped(_ sender: UIButton) {
        print("Favourite Tapped")
        filteredCruises[sender.tag].isFavourite.toggle()
        cruiseListTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
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

