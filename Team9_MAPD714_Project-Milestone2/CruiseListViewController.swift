//
//  CruiseListViewController.swift
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
// The file handles table view and populates the view with details

import UIKit

class CruiseListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
        
    let cruises = [
        Cruise(name: "Caribbean Breeze", nights: 7, departurePort: "Miami", cost: 1000, imageName: "cruiseImage1", numPorts: 5),
            Cruise(name: "Alaskan Adventure", nights: 10, departurePort: "Seattle", cost: 1500, imageName: "cruiseImage2", numPorts: 7),
            Cruise(name: "Mediterranean Marvel", nights: 8, departurePort: "Barcelona", cost: 1400, imageName: "cruiseImage3", numPorts: 6),
            Cruise(name: "Hawaiian Paradise", nights: 12, departurePort: "Honolulu", cost: 1800, imageName: "cruiseImage4", numPorts: 9),
            Cruise(name: "Tropical Escape", nights: 6, departurePort: "Cancun", cost: 1200, imageName: "cruiseImage5", numPorts: 4),
            Cruise(name: "Exotic Far East", nights: 14, departurePort: "Singapore", cost: 2200, imageName: "cruiseImage6", numPorts: 10),
            Cruise(name: "Tahitian Treasures", nights: 9, departurePort: "Papeete", cost: 1700, imageName: "cruiseImage7", numPorts: 6),
            Cruise(name: "Baltic Beauty", nights: 11, departurePort: "Copenhagen", cost: 1600, imageName: "cruiseImage8", numPorts: 8),
            Cruise(name: "African Safari Cruise", nights: 13, departurePort: "Cape Town", cost: 2100, imageName: "cruiseImage9", numPorts: 9),
            Cruise(name: "Galapagos Explorer", nights: 7, departurePort: "Quito", cost: 1900, imageName: "cruiseImage1", numPorts: 4)
    ]

        
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Set the data source for the table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        backButton.tintColor = UIColor.black

        // Set the custom back button for this view controller
        self.navigationItem.backBarButtonItem = backButton
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cruises.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CruiseCell", for: indexPath) as! CruiseTableViewCell
        let cruise = cruises[indexPath.row]
        cell.configure(with: cruise)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected item
        let selectedCruise = cruises[indexPath.row]
        
        // Perform the desired action, e.g., push a new view controller
        let detailsViewController = self.storyboard!.instantiateViewController(withIdentifier: "CruiseDetailsViewController") as! CruiseDetailsViewController
        
        detailsViewController.cruise = selectedCruise // Pass data to the details view
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

class Cruise {
    var name: String
    var nights: Int
    var departurePort: String
    var cost: Double
    var imageName: String
    var numPorts: Int
    
    init(name: String, nights: Int, departurePort: String, cost: Double, imageName: String, numPorts: Int) {
        self.name = name
        self.nights = nights
        self.departurePort = departurePort
        self.cost = cost
        self.imageName = imageName
        self.numPorts = numPorts
    }
}

class CruiseTableViewCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet var cruiseImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nightsLabel: UILabel!
    @IBOutlet var departurePortLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var numPortsLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with cruise: Cruise) {
        setupCardView()
        
        cruiseImageView.image = UIImage(named: cruise.imageName)
//        cruiseImageView.image = cruiseImage
        cruiseImageView.contentMode = .scaleAspectFill // This sets the content mode to "cover"
        cruiseImageView.clipsToBounds = true // This ensures the image is clipped to the bounds
        cruiseImageView.translatesAutoresizingMaskIntoConstraints = false // Enable auto layout constraints

        // Set the height to 200px
        cruiseImageView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        if let superview = cruiseImageView.superview {
            cruiseImageView.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 1.0).isActive = true
        }
//        cruiseImageView.widthAnchor.constraint(equalTo: superview!.widthAnchor, multiplier: 1.0).isActive = true

        // Set the width to 100% of the parent view (assuming you are using Auto Layout)
//        cruiseImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true        
        
        nameLabel.text = cruise.name
        nightsLabel.text = "\(cruise.nights) Nights"
        departurePortLabel.text = "\(cruise.departurePort)"
        costLabel.text = "$\(cruise.cost)"
        numPortsLabel.text = "\(cruise.numPorts) Ports"
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
    }
}
