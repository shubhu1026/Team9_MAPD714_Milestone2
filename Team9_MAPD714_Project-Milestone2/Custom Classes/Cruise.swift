//
//  HomeViewController.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-10-28.
//
//
//  Team Number: 9
//  Milestone Number: 2
//
//  Team Members:
//  Shubham Patel - 301366205
//  Anmol Sharma - 301364872
//  Submission date - 1 Dec 2023
//
//  stores details about cruise and related itinerary


import Foundation

let dbManager = DatabaseManager()

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
    var visitingPorts : [PortInfo]
    
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
        self.visitingPorts = dbManager.fetchPortsForCruise(name: name)
    }
}

struct PortInfo {
    let name: String
    let time: String
    let date: String
    let portImage : String
}
