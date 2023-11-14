//
//  TicketViewController.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-11-14.
//

import UIKit

class TicketViewController: UIViewController, UITableViewDataSource,
UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tickeTitleLabel: UILabel!
    
    // Assuming yourDataArray is an array of YourData objects
    var data: [Itinerary] = [
        Itinerary(date: "2023-11-14", place: "Sample Place 1", time: "12:00 PM", imageName: "cruiseImage1"),
        Itinerary(date: "2023-11-15", place: "Sample Place 2", time: "3:30 PM", imageName: "cruiseImage2"),
        Itinerary(date: "2023-11-16", place: "Sample Place 3", time: "2:10 PM", imageName: "cruiseImage3"),
        Itinerary(date: "2023-11-17", place: "Sample Place 4", time: "6:00 PM", imageName: "cruiseImage4"),
    ]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itineraryCell", for: indexPath) as! ItineraryTableViewCell
        
        let data = data[indexPath.row]
        cell.setupItineraryCell(itinerary: data)

        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        setupBackground()
    }
    
    func setupBackground() {
        let background = UIImage(named: "bgTicket")
        
        var imageView: UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.layer.cornerRadius = 10
        imageView.center = view.center
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: tickeTitleLabel.bottomAnchor, constant: 30).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22).isActive = true
        
        self.view.sendSubviewToBack(imageView)
    }
}

