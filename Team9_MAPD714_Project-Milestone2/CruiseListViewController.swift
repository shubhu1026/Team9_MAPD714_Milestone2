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
        Cruise(name: "Cruise 1", nights: 7, departurePort: "Miami", cost: 1000, imageName: "cruiseImage", numPorts: 5),
        Cruise(name: "Cruise 2", nights: 5, departurePort: "Los Angeles", cost: 1200, imageName: "cruiseImage", numPorts: 4),
        Cruise(name: "Cruise 3", nights: 10, departurePort: "New York", cost: 1500, imageName: "cruiseImage", numPorts: 7),
        Cruise(name: "Cruise 4", nights: 3, departurePort: "San Francisco", cost: 800, imageName: "cruiseImage", numPorts: 2),
        Cruise(name: "Cruise 5", nights: 8, departurePort: "Sydney", cost: 2000, imageName: "cruiseImage", numPorts: 6),
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
