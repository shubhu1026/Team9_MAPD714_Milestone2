//
//  CruiseOperations.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-12-11.
//

import Foundation
import SQLite3

extension DatabaseManager{
    func getCruises() -> [Cruise] {
        var cruises: [Cruise] = []
        var queryStatement: OpaquePointer?
        
        let query = "SELECT cruise_name, cruise_cost, cruise_length_nights, operator_name, trip_from, trip_to, ports_count, departure_date, cruise_image FROM Cruises"
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let name = String(cString: sqlite3_column_text(queryStatement, 0))
                let cost = Int(sqlite3_column_int(queryStatement, 1))
                let nights = Int(sqlite3_column_int(queryStatement, 2))
                let operatorName = String(cString: sqlite3_column_text(queryStatement, 3))
                let tripFrom = String(cString: sqlite3_column_text(queryStatement, 4))
                let tripTo = String(cString: sqlite3_column_text(queryStatement, 5))
                let portsCount = Int(sqlite3_column_int(queryStatement, 6))
                let date = String(cString: sqlite3_column_text(queryStatement, 7))
                let imageName = String(cString: sqlite3_column_text(queryStatement, 8))
                
                let cruise = Cruise(name: name, imageName: imageName, nights: nights, operatorName: operatorName, tripFrom: tripFrom, tripTo: tripTo, portsCount: portsCount, departureDate: date, avgPersonCost: Double(cost))
                
                // Fetch and assign ports information for this cruise
                let portsForCruise = fetchPortsForCruise(name: name)
                cruise.visitingPorts = portsForCruise
                
                cruises.append(cruise)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        
        return cruises
    }
    
    func fetchPortsForCruise(name: String) -> [PortInfo] {
        var ports: [PortInfo] = []
        var queryStatement: OpaquePointer?
        
        let query = "SELECT port_name, time, date, port_image FROM Cruise_Itinerary WHERE cruise_id = (SELECT cruise_id FROM Cruises WHERE cruise_name = ?)"
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (name as NSString).utf8String, -1, nil)
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let portName = String(cString: sqlite3_column_text(queryStatement, 0))
                let time = String(cString: sqlite3_column_text(queryStatement, 1))
                let date = String(cString: sqlite3_column_text(queryStatement, 2))
                let portImage = String(cString: sqlite3_column_text(queryStatement, 3))
                
                let portInfo = PortInfo(name: portName, time: time, date: date, portImage: portImage)
                ports.append(portInfo)
            }
        } else {
            print("SELECT statement for ports could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        
        return ports
    }
    
    func getCruiseID(forCruiseName name: String) -> Int? {
        var cruiseID: Int?
        
        var queryStatement: OpaquePointer?
        
        let query = "SELECT cruise_id FROM Cruises WHERE cruise_name = ?"
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (name as NSString).utf8String, -1, nil)
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                cruiseID = Int(sqlite3_column_int(queryStatement, 0))
            }
        }
        
        sqlite3_finalize(queryStatement)
        
        return cruiseID
    }
    
    
    func fetchItineraryForCruise(withID cruiseID: Int) -> [Itinerary] {
        var itineraries: [Itinerary] = []
        var queryStatement: OpaquePointer?
        
        let query = "SELECT port_name, time, date FROM Cruise_Itinerary WHERE cruise_id = ?"
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(cruiseID))
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let portName = String(cString: sqlite3_column_text(queryStatement, 0))
                let time = String(cString: sqlite3_column_text(queryStatement, 1))
                let date = String(cString: sqlite3_column_text(queryStatement, 2))
                
                let itinerary = Itinerary(date: date, place: portName, time: time, imageName: "imageName")
                itineraries.append(itinerary)
            }
        } else {
            print("SELECT statement for itinerary could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        
        return itineraries
    }
    
    func getUniqueTripToValues() -> [String] {
        var tripToValues: [String] = []
        var queryStatement: OpaquePointer?

        let query = "SELECT DISTINCT trip_to FROM Cruises" // Assuming 'Cruises' is your table name

        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                if let tripToValue = sqlite3_column_text(queryStatement, 0) {
                    let tripTo = String(cString: tripToValue)
                    tripToValues.append(tripTo)
                }
            }
        }

        sqlite3_finalize(queryStatement)
        return tripToValues
    }
    
    func getAllUniquePorts() -> [String] {
            var ports: [String] = []

            let query = "SELECT DISTINCT port_name FROM Cruise_Itinerary"
            var queryStatement: OpaquePointer?

            if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    if let portName = sqlite3_column_text(queryStatement, 0) {
                        let port = String(cString: portName)
                        ports.append(port)
                    }
                }
            } else {
                print("Error preparing SELECT statement")
            }

            sqlite3_finalize(queryStatement)

            return ports
        }
    
}
