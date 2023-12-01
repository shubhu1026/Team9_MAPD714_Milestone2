//
//  BookingDetails.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-12-01.
//

import Foundation

struct BookingDetails {
    let bookedBy: String
    let bookingDate : String
    let totalRooms: Int
    let cruiseSelected : Cruise
    let GuestDetails : [GuestDetail]
    let tripFrom: String
    let tripTo: String
    let visitingPorts : [PortInfo]
    let totalTripFare: Double
    let ticketId : String
}

struct GuestDetail {
      let name : String
      let gender : String
      let age : Int
}
