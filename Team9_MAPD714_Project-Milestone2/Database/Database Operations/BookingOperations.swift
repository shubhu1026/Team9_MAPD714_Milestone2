//
//  BookingOperations.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-12-11.
//

import Foundation
import SQLite3

extension DatabaseManager {
    
    func doesTicketNumberExist(ticketNumber: String) -> Bool {
        var queryStatement: OpaquePointer?
        let query = "SELECT ticketId FROM Bookings WHERE ticketId = ?;"
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (ticketNumber as NSString).utf8String, -1, nil)
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                // Ticket number exists in the database
                sqlite3_finalize(queryStatement)
                return true
            }
        }
        
        sqlite3_finalize(queryStatement)
        return false
    }
    
    func insertBooking(booking: BookingDetails, userId: Int) {
        var insertStatement: OpaquePointer?
        
        if let cruiseId = getCruiseID(forCruiseName: booking.cruiseSelected.name) {
            let insertQuery = """
                INSERT INTO Bookings (userId, cruiseId, roomsCount, guestsCount, totalFare, bookingDate)
                VALUES (?, ?, ?, ?, ?, ?);
            """
            
            if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(insertStatement, 1, Int32(userId))
                sqlite3_bind_int(insertStatement, 2, Int32(cruiseId))
                sqlite3_bind_int(insertStatement, 3, Int32(booking.totalRooms))
                sqlite3_bind_int(insertStatement, 4, Int32(booking.GuestDetails.count))
                sqlite3_bind_double(insertStatement, 5, booking.totalTripFare)
                sqlite3_bind_text(insertStatement, 6, (booking.bookingDate as NSString).utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Booking inserted successfully")
                } else {
                    print("Failed to insert booking")
                }
            } else {
                print("Insert statement could not be prepared")
            }
            
            sqlite3_finalize(insertStatement)
        } else {
            print("Cruise ID not found for the given name: \(booking.cruiseSelected.name)")
        }
    }
    
    func insertFamilyMembers(forBooking booking: BookingDetails, bookingId: String, userId: Int) {
        var statement: OpaquePointer?
        
        let query = """
            INSERT INTO Users_Family_Members (user_id, booking_id, name, age, gender)
            VALUES (?, ?, ?, ?, ?);
        """
        
        for guestDetail in booking.GuestDetails {
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_int(statement, 1, Int32(userId))
                sqlite3_bind_text(statement, 2, (bookingId as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 3, (guestDetail.name as NSString).utf8String, -1, nil)
                sqlite3_bind_int(statement, 4, Int32(guestDetail.age))
                sqlite3_bind_text(statement, 5, (guestDetail.gender as NSString).utf8String, -1, nil)
                
                if sqlite3_step(statement) != SQLITE_DONE {
                    print("Failed to insert passenger details")
                }
            } else {
                print("Passenger Details insertion failed")
            }
            sqlite3_reset(statement)
        }
        
        sqlite3_finalize(statement)
    }

}
