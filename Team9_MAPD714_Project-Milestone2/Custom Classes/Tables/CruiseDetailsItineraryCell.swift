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
    
    @IBOutlet weak var portImage: UIImageView!
    func setupCruiseDetailsItineraryCell(portInfo: PortInfo)
    {
        timeLabel.text = portInfo.time
        dateLabel.text = portInfo.date
        spotNameLabel.text = portInfo.name
        portImage.image = UIImage(named: portInfo.portImage)
        
        portImage.layer.cornerRadius = 8 // Adjust this value as needed for your desired corner radius
        portImage.layer.masksToBounds = true // Ensures the image respects the rounded corners
    }
}

