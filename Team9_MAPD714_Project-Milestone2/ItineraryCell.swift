//
//  ItineraryCell.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-11-14.
//

import Foundation
import UIKit

class ItineraryTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var spotNameLabel: UILabel!
    @IBOutlet weak var spotImageView: UIImageView!
    
    func setupItineraryCell(itinerary: Itinerary)
    {
        timeLabel.text = itinerary.time
        dateLabel.text = itinerary.date
        spotNameLabel.text = itinerary.place
        spotImageView.image = UIImage(named: itinerary.imageName)
    }
}
