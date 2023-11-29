//
//  CruiseDetailsItineraryCell.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-11-27.
//

import Foundation
import UIKit

class CruiseDetailsItineraryTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var spotNameLabel: UILabel!
    
    func setupCruiseDetailsItineraryCell(itinerary: Itinerary)
    {
        timeLabel.text = itinerary.time
        dateLabel.text = itinerary.date
        spotNameLabel.text = itinerary.place
    }
}
