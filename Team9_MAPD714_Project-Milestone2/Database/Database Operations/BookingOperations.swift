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
                INSERT INTO Bookings (userId, cruiseId, roomsCount, guestsCount, totalFare, bookingDate, bookedBy, ticketId)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?);
            """
            
            if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(insertStatement, 1, Int32(userId))
                sqlite3_bind_int(insertStatement, 2, Int32(cruiseId))
                sqlite3_bind_int(insertStatement, 3, Int32(booking.totalRooms))
                sqlite3_bind_int(insertStatement, 4, Int32(booking.GuestDetails.count))
                sqlite3_bind_double(insertStatement, 5, booking.totalTripFare)
                sqlite3_bind_text(insertStatement, 6, (booking.bookingDate as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 7, (booking.bookedBy as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 8, (booking.ticketId as NSString).utf8String, -1, nil)
                
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

    
    func getBookingsForUser(userID: Int) -> [BookingDetails] {
        var bookings = [BookingDetails]()
        var queryStatement: OpaquePointer?
        let query = "SELECT * FROM Bookings WHERE userId = ?;"
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(userID))
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let bookingID = Int(sqlite3_column_int(queryStatement, 0))
                let cruiseID = Int(sqlite3_column_int(queryStatement, 2))
                let roomsCount = Int(sqlite3_column_int(queryStatement, 3))
                let guestsCount = Int(sqlite3_column_int(queryStatement, 4))
                let totalFare = Double(sqlite3_column_double(queryStatement, 5))
                let bookedBy = String(cString: sqlite3_column_text(queryStatement, 7))
                let ticketId = String(cString: sqlite3_column_text(queryStatement, 8))
                let bookingDate = String(cString: sqlite3_column_text(queryStatement, 6))
                
                print("BookingID: \(bookingID), CruiseID: \(cruiseID), RoomsCount: \(roomsCount), GuestsCount: \(guestsCount), TotalFare: \(totalFare), BookedBy: \(bookedBy), TicketID: \(ticketId), BookingDate: \(bookingDate)")
                
                if let cruise = getCruiseDetails(cruiseId: cruiseID) {
                    print("Cruise found for CruiseID: \(cruiseID)")
                    if let guestDetails = getGuestDetails(bookingID: ticketId) {
                        print("GuestDetails found for BookingID: \(ticketId)")
                        let booking = BookingDetails(
                            bookedBy: bookedBy,
                            bookingDate: bookingDate,
                            totalRooms: roomsCount,
                            cruiseSelected: cruise,
                            GuestDetails: guestDetails,
                            totalTripFare: totalFare,
                            ticketId: ticketId
                        )
                        
                        bookings.append(booking)
                    } else {
                        print("GuestDetails not found for BookingID: \(ticketId)")
                    }
                } else {
                    print("Cruise not found for CruiseID: \(cruiseID)")
                }
            }
        } else {
            print("Error preparing SQL statement")
        }
        
        sqlite3_finalize(queryStatement)
        return bookings
    }

    func getGuestDetails(bookingID: String) -> [GuestDetail]? {
        var guestDetails = [GuestDetail]()
        var queryStatement: OpaquePointer?
        
        let query = "SELECT name, gender, age FROM Users_Family_Members WHERE booking_id = ?;"
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (bookingID as NSString).utf8String, -1, nil)
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let name = String(cString: sqlite3_column_text(queryStatement, 0))
                let gender = String(cString: sqlite3_column_text(queryStatement, 1))
                let age = Int(sqlite3_column_int(queryStatement, 2))
                
                let guest = GuestDetail(name: name, gender: gender, age: age)
                guestDetails.append(guest)
            }
        } else {
            print("SELECT statement for guest details could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        
        return guestDetails.isEmpty ? nil : guestDetails
    }

}


