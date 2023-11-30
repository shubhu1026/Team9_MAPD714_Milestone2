//
//  Cruise.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-11-29.
//

import Foundation

class Cruise {
    var name: String
    var cruiseImageName: String
    var totalNights: Int
    var operatorName: String
    var tripFrom: String
    var tripTo: String
    var portsCount: Int
    var departureDate: String
    var avgPersonCost: Double
    var isFavourite: Bool = false
    
    init(name: String, imageName: String, nights: Int, operatorName: String, tripFrom: String, tripTo: String, portsCount: Int, departureDate: String, avgPersonCost: Double) {
        self.name = name
        self.cruiseImageName = imageName
        self.totalNights = nights
        self.operatorName = operatorName
        self.tripFrom = tripFrom
        self.tripTo = tripTo
        self.portsCount = portsCount
        self.departureDate = departureDate
        self.avgPersonCost = avgPersonCost
    }
}
