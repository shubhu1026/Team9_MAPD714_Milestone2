//
//  CruiseTableViewCell.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-11-29.
//

import Foundation
import UIKit

class CruiseTableViewCell: UITableViewCell {
    @IBOutlet weak var cruiseImage: UIImageView!
    @IBOutlet weak var totalNights: UILabel!
    @IBOutlet weak var cruiseName: UILabel!
    @IBOutlet weak var operatorName: UILabel!
    @IBOutlet weak var tripFrom: UILabel!
    @IBOutlet weak var tripTo: UILabel!
    @IBOutlet weak var visitingPorts: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var heartSelected: UIButton!
    @IBOutlet var cardView: UIView!
    
    func configure(with cruise: Cruise) {
        cruiseImage.image = UIImage(named: cruise.cruiseImageName)
        totalNights.text = "\(cruise.totalNights) Nights"
        cruiseName.text = cruise.name
        operatorName.text = cruise.operatorName
        tripFrom.text = "\(cruise.tripFrom)"
        tripTo.text = "\(cruise.tripTo)"
        visitingPorts.text = "\(cruise.portsCount) Ports"
        totalPrice.text = "$\(cruise.avgPersonCost)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // Add padding
        let padding = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            contentView.frame = contentView.frame.inset(by: padding)
    }
}
