//
//  HomeViewController.swift
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
//  Submission date - 1 Dec 2023
//
//  class to store itinerary details


import Foundation
import UIKit

class Itinerary{
    let date: String
    let place: String
    let time: String
    let imageName: String
    
    init(date: String, place: String, time: String, imageName: String) {
        self.date = date
        self.place = place
        self.time = time
        self.imageName = imageName
    }
}
