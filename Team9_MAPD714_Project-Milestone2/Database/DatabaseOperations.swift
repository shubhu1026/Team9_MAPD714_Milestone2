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
//  functions for dealing wiht database


import Foundation
import SQLite3

extension DatabaseManager{
    func registerUser(name: String, email: String, password: String, address: String?, city: String?, country: String?, phoneNumber: String?) -> Bool {
        var statement: OpaquePointer?
        
        let query = "INSERT INTO Users (Name, email, password, address, city, country, phone_number) VALUES (?, ?, ?, ?, ?, ?, ?)"
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(statement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (password as NSString).utf8String, -1, nil)
            
            if let address = address {
                sqlite3_bind_text(statement, 4, (address as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(statement, 4)
            }
            
            if let city = city {
                sqlite3_bind_text(statement, 5, (city as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(statement, 5)
            }
            
            if let country = country {
                sqlite3_bind_text(statement, 6, (country as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(statement, 6)
            }
            
            if let phoneNumber = phoneNumber {
                sqlite3_bind_text(statement, 7, (phoneNumber as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(statement, 7)
            }
            
            if sqlite3_step(statement) == SQLITE_DONE {
                sqlite3_finalize(statement)
                return true // User registered successfully
            }
        }
        
        sqlite3_finalize(statement)
        return false // Registration failed
    }
    
    func loginUser(email: String, password: String) -> Bool {
        var statement: OpaquePointer?
        
        let query = "SELECT * FROM Users WHERE email = ? AND password = ?"
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (password as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_ROW {
                sqlite3_finalize(statement)
                return true // User authenticated
            }
        }
        
        sqlite3_finalize(statement)
        return false // Authentication failed
    }
    
    func doesEmailExist(email: String) -> Bool {
        var statement: OpaquePointer?
        
        let query = "SELECT * FROM Users WHERE email = ?"
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (email as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_ROW {
                // Email exists in the database
                sqlite3_finalize(statement)
                return true
            }
        }
        
        sqlite3_finalize(statement)
        return false
    }
    
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
    
    func getUserInfo(email: String) -> User? {
        var userInfo: User?
        var queryStatement: OpaquePointer?
        let query = "SELECT Name, email, address, city, country, phone_number FROM Users WHERE email = ?"
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (email as NSString).utf8String, -1, nil)
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let userName = String(cString: sqlite3_column_text(queryStatement, 0))
                let userEmail = String(cString: sqlite3_column_text(queryStatement, 1))
                let userAddress = String(cString: sqlite3_column_text(queryStatement, 2))
                let userCity = String(cString: sqlite3_column_text(queryStatement, 3))
                let userCountry = String(cString: sqlite3_column_text(queryStatement, 4))
                let userPhoneNumber = String(cString: sqlite3_column_text(queryStatement, 5))
                
                userInfo = User(userName: userName,
                                userEmail: userEmail,
                                userAddress: userAddress,
                                userCity: userCity,
                                userCountry: userCountry,
                                userPhoneNumber: userPhoneNumber)
            }
        }
        
        sqlite3_finalize(queryStatement)
        return userInfo
    }
    
    func updateUserInfo(user: User) -> Bool {
        var statement: OpaquePointer?
        
        let query = "UPDATE Users SET Name = ?, email = ?, address = ?, city = ?, country = ?, phone_number = ? WHERE email = ?"
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (user.userName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (user.userEmail as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (user.userAddress as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (user.userCity as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (user.userCountry as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 6, (user.userPhoneNumber as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 7, (user.userEmail as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                sqlite3_finalize(statement)
                return true // User information updated successfully
            }
        }
        
        sqlite3_finalize(statement)
        return false // Updating user information failed
    }
    
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

    func getUserId(forEmail email: String) -> Int? {
        var userId: Int?
        var queryStatement: OpaquePointer?
        
        let query = "SELECT user_id FROM Users WHERE email = ?"
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (email as NSString).utf8String, -1, nil)
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                userId = Int(sqlite3_column_int(queryStatement, 0))
            }
        }
        
        sqlite3_finalize(queryStatement)
        
        return userId
    }

}
