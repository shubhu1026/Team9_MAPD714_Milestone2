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
    
    func setupCruiseDetailsItineraryCell(portInfo: PortInfo)
    {
        timeLabel.text = portInfo.time
        dateLabel.text = portInfo.date
        spotNameLabel.text = portInfo.name
    }
}
