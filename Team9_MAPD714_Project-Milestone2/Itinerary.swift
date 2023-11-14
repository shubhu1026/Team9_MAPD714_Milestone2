//
//  Itinerary.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-11-14.
//

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
