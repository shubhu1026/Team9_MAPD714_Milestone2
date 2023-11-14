//
//  CheckoutViewController.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-11-13.
//

import UIKit

class CheckoutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let data = [
            ["10:00 AM", "2023-11-13", "Spot A", "cruiseImage1"],
            ["02:30 PM", "2023-11-14", "Spot B", "cruiseImage2"],
            // Add more data as needed
        ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows: \(data.count)")
            return data.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itineraryCell", for: indexPath) as! ItineraryTableViewCell

            // Configure the cell with data from your model
            cell.timeLabel.text = data[indexPath.row][0]
            cell.dateLabel.text = data[indexPath.row][1]
            cell.spotNameLabel.text = data[indexPath.row][2]
            cell.spotImageView.image = UIImage(named: data[indexPath.row][3])

            return cell
        }

    @IBOutlet weak var ticketTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setupCardView()
        setupBackground()
        // Do any additional setup after loading the view.
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
        imageView.topAnchor.constraint(equalTo: ticketTitle.bottomAnchor, constant: 30).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22).isActive = true
        
        self.view.sendSubviewToBack(imageView)
    }
      
    /*
    func setupCardView()
    {
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
        
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 2
        cardView.layer.masksToBounds = false
        
        self.view.sendSubviewToBack(cardView)
    }
     */
}

class ItineraryTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var spotNameLabel: UILabel!
    @IBOutlet weak var spotImageView: UIImageView!
}
