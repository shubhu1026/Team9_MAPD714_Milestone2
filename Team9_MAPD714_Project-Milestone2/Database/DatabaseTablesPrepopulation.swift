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
//  Prepopulates tables for cruise and itenerary

import Foundation
import SQLite3

extension DatabaseManager {
    func isDataPrepopulated() -> Bool {
        var statement: OpaquePointer?
        let query = "SELECT COUNT(*) FROM Cruises"
            
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            defer { sqlite3_finalize(statement) }
                
            if sqlite3_step(statement) == SQLITE_ROW {
                let count = sqlite3_column_int(statement, 0)
                return count > 0 // If count > 0, data is already prepopulated
            }
        }
            
        return false // Default to false if any error occurs or no data found
    }
    
    func prepopulateCruiseData() {
        let cruisesData = [
            ("Caribbean Breeze", 1000, 7, "Miami", "Caribbean", "Ocean Cruises", "2024-01-15", 5, "cruiseImage1"),
            ("Alaskan Adventure", 1500, 10, "Seattle", "Alaska", "Northern Lights Tours", "2024-02-20", 7, "cruiseImage2"),
            ("Mediterranean Marvel", 1400, 8, "Barcelona", "Mediterranean", "Mediterranean Ventures", "2024-03-25", 6, "cruiseImage3"),
            ("Hawaiian Paradise", 1800, 12, "Honolulu", "Hawaiian Islands", "Tropical Cruises", "2024-04-30", 9, "cruiseImage4"),
            ("Tropical Escape", 1200, 6, "Cancun", "Tropical", "Caribbean Getaways", "2024-05-15", 4, "cruiseImage5"),
            ("Exotic Far East", 2200, 14, "Singapore", "Far East", "Eastern Dreams", "2024-06-20", 10, "cruiseImage6"),
            ("Tahitian Treasures", 1700, 9, "Papeete", "Tahitian", "Tahiti Cruises", "2024-07-25", 6, "cruiseImage7"),
            ("Baltic Beauty", 1600, 11, "Copenhagen", "Baltic", "Northern Voyages", "2024-08-30", 8, "cruiseImage8"),
            ("African Safari Cruise", 2100, 13, "Cape Town", "Africa", "Safari Cruises", "2024-09-15", 9, "cruiseImage9"),
            ("Galapagos Explorer", 1900, 7, "Quito", "Galapagos", "Galapagos Adventures", "2024-10-20", 4, "cruiseImage1")
        ]

        for cruiseData in cruisesData {
            let insertStatementString = "INSERT INTO Cruises (cruise_name, cruise_cost, cruise_length_nights, trip_from, trip_to, operator_name, departure_date, ports_count, cruise_image) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);"

            var insertStatement: OpaquePointer?

            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                let name = NSString(string: cruiseData.0).utf8String
                let cost = Int32(cruiseData.1)
                let length = Int32(cruiseData.2)
                let from = NSString(string: cruiseData.3).utf8String
                let to = NSString(string: cruiseData.4).utf8String
                let operatorName = NSString(string: cruiseData.5).utf8String
                let date = NSString(string: cruiseData.6).utf8String
                let ports = Int32(cruiseData.7)
                let imageName = NSString(string: cruiseData.8).utf8String

                sqlite3_bind_text(insertStatement, 1, name, -1, nil)
                sqlite3_bind_int(insertStatement, 2, cost)
                sqlite3_bind_int(insertStatement, 3, length)
                sqlite3_bind_text(insertStatement, 4, from, -1, nil)
                sqlite3_bind_text(insertStatement, 5, to, -1, nil)
                sqlite3_bind_text(insertStatement, 6, operatorName, -1, nil)
                sqlite3_bind_text(insertStatement, 7, date, -1, nil)
                sqlite3_bind_int(insertStatement, 8, ports)
                sqlite3_bind_text(insertStatement, 9, imageName, -1, nil)

                if sqlite3_step(insertStatement) != SQLITE_DONE {
                    print("Error inserting cruise data")
                }

                sqlite3_finalize(insertStatement)
            } else {
                print("Error preparing insert statement")
            }
        }
    }

    
    func prepopulateCruiseItinerary() {
        let cruiseData: [(String, [(String, String, String)])] = [
            ("Caribbean Breeze", [
                ("Port of Miami", "10:00 AM", "2023-01-01"),
                ("Nassau", "12:00 PM", "2023-01-02"),
                ("CocoCay", "02:00 PM", "2023-01-03"),
                ("St. Thomas", "04:00 PM", "2023-01-04"),
                ("St. Maarten", "06:00 PM", "2023-01-05")
            ]),
            ("Mediterranean Marvel", [
                ("Barcelona", "10:00 AM", "2023-02-01"),
                ("Marseille", "12:00 PM", "2023-02-02"),
                ("Rome", "02:00 PM", "2023-02-03"),
                ("Athens", "04:00 PM", "2023-02-04"),
                ("Venice", "06:00 PM", "2023-02-05")
            ]),
            ("Alaskan Adventure", [
                ("Seattle", "10:00 AM", "2023-03-01"),
                ("Juneau", "12:00 PM", "2023-03-02"),
                ("Skagway", "02:00 PM", "2023-03-03"),
                ("Ketchikan", "04:00 PM", "2023-03-04"),
                ("Anchorage", "06:00 PM", "2023-03-05")
            ]),
            ("Hawaiian Paradise", [
                ("Honolulu", "10:00 AM", "2023-04-01"),
                ("Maui", "12:00 PM", "2023-04-02"),
                ("Kauai", "02:00 PM", "2023-04-03"),
                ("Hilo", "04:00 PM", "2023-04-04"),
                ("Big Island", "06:00 PM", "2023-04-05")
            ]),
            ("Exotic Far East", [
                ("Singapore", "10:00 AM", "2023-06-01"),
                ("Phuket", "12:00 PM", "2023-06-02"),
                ("Ho Chi Minh City", "02:00 PM", "2023-06-03"),
                ("Hong Kong", "04:00 PM", "2023-06-04"),
                ("Tokyo", "06:00 PM", "2023-06-05")
            ]),
            ("Tahitian Treasures", [
                ("Papeete", "10:00 AM", "2023-07-01"),
                ("Bora Bora", "12:00 PM", "2023-07-02"),
                ("Moorea", "02:00 PM", "2023-07-03"),
                ("Raiatea", "04:00 PM", "2023-07-04"),
                ("Huahine", "06:00 PM", "2023-07-05")
            ]),
            ("Baltic Beauty", [
                ("Copenhagen", "10:00 AM", "2023-08-01"),
                ("Stockholm", "12:00 PM", "2023-08-02"),
                ("St. Petersburg", "02:00 PM", "2023-08-03"),
                ("Helsinki", "04:00 PM", "2023-08-04"),
                ("Tallinn", "06:00 PM", "2023-08-05")
            ]),
            ("Tropical Escape", [
                ("Cancun", "10:00 AM", "2023-05-01"),
                ("Cozumel", "12:00 PM", "2023-05-02"),
                ("Roatan", "02:00 PM", "2023-05-03"),
                ("Belize", "04:00 PM", "2023-05-04"),
                ("Costa Maya", "06:00 PM", "2023-05-05")
            ]),
            ("African Safari Cruise", [
                ("Cape Town", "10:00 AM", "2023-09-01"),
                ("Port Elizabeth", "12:00 PM", "2023-09-02"),
                ("Durban", "02:00 PM", "2023-09-03"),
                ("Maputo", "04:00 PM", "2023-09-04"),
                ("Richards Bay", "06:00 PM", "2023-09-05")
            ]),
            ("Galapagos Explorer", [
                ("Quito", "10:00 AM", "2023-10-01"),
                ("Baltra Island", "12:00 PM", "2023-10-02"),
                ("San Cristobal Island", "02:00 PM", "2023-10-03"),
                ("Isabela Island", "04:00 PM", "2023-10-04"),
                ("Santa Cruz Island", "06:00 PM", "2023-10-05")
            ])
        ]
        
        for cruise in cruiseData {
                if let cruiseID = getCruiseID(forCruiseName: cruise.0) {
                    for portInfo in cruise.1 {
                        let portName = portInfo.0
                        let time = portInfo.1
                        let date = portInfo.2
                        
                        let randomNumber = Int.random(in: 1...9) // Generating a random number from 1 to 9
                        let portImage = "portImage\(randomNumber)"// Include port image information
                        
                        insertItineraryForCruise(cruiseID: cruiseID, portName: portName, time: time, date: date, portImage: portImage)
                    }
                }
            }
    }


    func insertItineraryForCruise(cruiseID: Int, portName: String, time: String, date: String, portImage: String) {
        let insertStatementString = "INSERT INTO Cruise_Itinerary (cruise_id, port_name, time, date, port_image) VALUES (?, ?, ?, ?, ?);"
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(cruiseID))
            sqlite3_bind_text(insertStatement, 2, (portName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (time as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (date as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (portImage as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) != SQLITE_DONE {
                print("Error inserting cruise itinerary data")
            }
            
            sqlite3_finalize(insertStatement)
        } else {
            print("Error preparing insert statement for cruise itinerary")
        }
    }
}

