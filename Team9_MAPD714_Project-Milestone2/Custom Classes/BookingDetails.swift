//
//  HomeViewController.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Anmol Sharma on 2023-11-28.
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
//  used for storing booking details

import Foundation

struct BookingDetails {
    let bookedBy: String
    let bookingDate : String
    let totalRooms: Int
    let cruiseSelected : Cruise
    let GuestDetails : [GuestDetail]
    let totalTripFare: Double
    let ticketId : String
}

struct GuestDetail {
      let name : String
      let gender : String
      let age : Int
}
