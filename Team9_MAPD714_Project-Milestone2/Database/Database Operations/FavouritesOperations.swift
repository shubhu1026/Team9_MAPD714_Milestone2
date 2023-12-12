//
//  FavouritesOperations.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-12-11.
//

import Foundation
import SQLite3

extension DatabaseManager{
    
    func getFavouriteCruises(forUserId userId: Int) -> [Cruise] {
        var favouriteCruises: [Cruise] = []
        var queryStatement: OpaquePointer?

        let query = """
            SELECT c.cruise_name, c.cruise_cost, c.cruise_length_nights, c.operator_name, c.trip_from, c.trip_to, c.ports_count, c.departure_date, c.cruise_image
            FROM Cruises c
            WHERE c.cruise_id IN (SELECT f.cruise_id FROM Favourites f WHERE f.user_id = ?);
        """

        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(userId))

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

                favouriteCruises.append(cruise)
            }
        } else {
            print("SELECT statement could not be prepared")
        }

        sqlite3_finalize(queryStatement)

        return favouriteCruises
    }
    
    func toggleFavouriteCruise(forUserId userId: Int?, cruise: Cruise) {
        guard let userId = userId else {
            print("User ID is nil")
            return
        }
        
        guard let cruiseId = getCruiseID(forCruiseName: cruise.name) else {
            print("Cruise ID is nil")
            return
        }
        
        if cruise.isFavourite {
            // If the cruise is marked as a favorite, add it to the Favourites table
            if !isCruiseInFavourites(forUserId: userId, cruiseId: cruiseId) {
                addCruiseToFavourites(forUserId: userId, cruiseId: cruiseId)
            }
        } else {
            // If the cruise is not marked as a favorite, remove it from the Favourites table
            if isCruiseInFavourites(forUserId: userId, cruiseId: cruiseId) {
                removeCruiseFromFavourites(forUserId: userId, cruiseId: cruiseId)
            }
        }
    }

    func isCruiseInFavourites(forUserId userId: Int, cruiseId: Int) -> Bool {
        let query = "SELECT * FROM Favourites WHERE user_id = ? AND cruise_id = ?"
        
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(userId))
            sqlite3_bind_int(queryStatement, 2, Int32(cruiseId)) // Assuming cruise.id is the ID of the cruise
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                sqlite3_finalize(queryStatement)
                return true // Cruise is in the Favourites table for this user
            }
        }
        
        sqlite3_finalize(queryStatement)
        return false // Cruise is not in the Favourites table for this user
    }

    func addCruiseToFavourites(forUserId userId: Int, cruiseId: Int) {
        let insertQuery = "INSERT INTO Favourites (user_id, cruise_id) VALUES (?, ?)"
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(userId))
            sqlite3_bind_int(insertStatement, 2, Int32(cruiseId)) // Assuming cruise.id is the ID of the cruise
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Cruise added to Favourites")
            } else {
                print("Failed to add cruise to Favourites")
            }
        }
        
        sqlite3_finalize(insertStatement)
    }

    func removeCruiseFromFavourites(forUserId userId: Int, cruiseId: Int) {
        let deleteQuery = "DELETE FROM Favourites WHERE user_id = ? AND cruise_id = ?"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(userId))
            sqlite3_bind_int(deleteStatement, 2, Int32(cruiseId)) // Assuming cruise.id is the ID of the cruise
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Cruise removed from Favourites")
            } else {
                print("Failed to remove cruise from Favourites")
            }
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
}
