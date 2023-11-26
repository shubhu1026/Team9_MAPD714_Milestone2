//
//  DatabaseManager.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-11-25.
//

import Foundation
import SQLite3

class DatabaseManager {
    var db: OpaquePointer?

    init() {
        // Path to the SQLite database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("cruise_app_database.sqlite")

        // Open or create the SQLite database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        } else {
            print("Successfully opened connection to database")
        }
    }

    func createTables() {
        var createTableStatement: OpaquePointer?

        let createUsersTable = """
            CREATE TABLE IF NOT EXISTS Users (
                user_id INTEGER PRIMARY KEY AUTOINCREMENT,
                Name TEXT NOT NULL,
                email TEXT UNIQUE NOT NULL,
                password TEXT NOT NULL,
                address TEXT,
                city TEXT,
                country TEXT
            );
        """

        let createCruisesTable = """
            CREATE TABLE IF NOT EXISTS Cruises (
                cruise_id INTEGER PRIMARY KEY AUTOINCREMENT,
                cruise_name TEXT NOT NULL,
                cruise_cost INTEGER,
                cruise_length_nights INTEGER,
                departure_destination TEXT,
                departure_date TEXT,
                ports_count INTEGER,
                cruise_image TEXT
            );
        """

        let createUsersFamilyMembersTable = """
            CREATE TABLE IF NOT EXISTS Users_Family_Members (
                member_id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id INTEGER REFERENCES Users(user_id),
                name TEXT NOT NULL,
                age INTEGER,
                gender TEXT
            );
        """

        let createCruiseItineraryTable = """
            CREATE TABLE IF NOT EXISTS Cruise_Itinerary (
                itinerary_id INTEGER PRIMARY KEY AUTOINCREMENT,
                cruise_id INTEGER REFERENCES Cruises(cruise_id),
                port_name TEXT,
                time TEXT,
                date DATE
            );
        """

        if sqlite3_prepare_v2(db, createUsersTable, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Users table created successfully")
            } else {
                print("Users table could not be created")
            }
        }

        if sqlite3_prepare_v2(db, createCruisesTable, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Cruises table created successfully")
            } else {
                print("Cruises table could not be created")
            }
        }

        if sqlite3_prepare_v2(db, createUsersFamilyMembersTable, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Users Family Members table created successfully")
            } else {
                print("Users Family Members table could not be created")
            }
        }

        if sqlite3_prepare_v2(db, createCruiseItineraryTable, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Cruise Itinerary table created successfully")
            } else {
                print("Cruise Itinerary table could not be created")
            }
        }

        sqlite3_finalize(createTableStatement)
    }
    
    func registerUser(name: String, email: String, password: String, address: String?, city: String?, country: String?) -> Bool {
            var statement: OpaquePointer?

            let query = "INSERT INTO Users (Name, email, password, address, city, country) VALUES (?, ?, ?, ?, ?, ?)"

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

    func prepopulateCruiseData() {
        let cruisesData = [
            ("Caribbean Breeze", 1000, 7, "Miami", "2024-01-15", 5, "cruiseImage1"),
            ("Alaskan Adventure", 1500, 10, "Seattle", "2024-02-20", 7, "cruiseImage2"),
            ("Mediterranean Marvel", 1400, 8, "Barcelona", "2024-03-25", 6, "cruiseImage3"),
            ("Hawaiian Paradise", 1800, 12, "Honolulu", "2024-04-30", 9, "cruiseImage4"),
            ("Tropical Escape", 1200, 6, "Cancun", "2024-05-15", 4, "cruiseImage5"),
            ("Exotic Far East", 2200, 14, "Singapore", "2024-06-20", 10, "cruiseImage6"),
            ("Tahitian Treasures", 1700, 9, "Papeete", "2024-07-25", 6, "cruiseImage7"),
            ("Baltic Beauty", 1600, 11, "Copenhagen", "2024-08-30", 8, "cruiseImage8"),
            ("African Safari Cruise", 2100, 13, "Cape Town", "2024-09-15", 9, "cruiseImage9"),
            ("Galapagos Explorer", 1900, 7, "Quito", "2024-10-20", 4, "cruiseImage1")
        ]
        
        for cruiseData in cruisesData {
                let insertStatementString = "INSERT INTO Cruises (cruise_name, cruise_length_nights, cruise_cost, departure_destination, departure_date, ports_count, cruise_image) VALUES (?, ?, ?, ?, ?, ?, ?);"

                var insertStatement: OpaquePointer?

                if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                    let name = NSString(string: cruiseData.0).utf8String
                    let length = Int32(cruiseData.1)
                    let cost = Int32(cruiseData.2)
                    let destination = NSString(string: cruiseData.3).utf8String
                    let date = NSString(string: cruiseData.4).utf8String
                    let ports = Int32(cruiseData.5)
                    let imageName = NSString(string: cruiseData.6).utf8String

                    sqlite3_bind_text(insertStatement, 1, name, -1, nil)
                    sqlite3_bind_int(insertStatement, 2, cost)
                    sqlite3_bind_int(insertStatement, 3, length)
                    sqlite3_bind_text(insertStatement, 4, destination, -1, nil)
                    sqlite3_bind_text(insertStatement, 5, date, -1, nil)
                    sqlite3_bind_int(insertStatement, 6, ports)
                    sqlite3_bind_text(insertStatement, 7, imageName, -1, nil)

                    if sqlite3_step(insertStatement) != SQLITE_DONE {
                        print("Error inserting cruise data")
                    }

                    sqlite3_finalize(insertStatement)
                } else {
                    print("Error preparing insert statement")
                }
        }
    }
    
    func getCruises() -> [Cruise] {
        var cruises: [Cruise] = []
        var queryStatement: OpaquePointer?

        let query = "SELECT cruise_Name, cruise_cost, cruise_length_nights, departure_destination, departure_date, ports_count, cruise_image FROM Cruises"

        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let name = String(cString: sqlite3_column_text(queryStatement, 0))
                let cost = Int(sqlite3_column_int(queryStatement, 1))
                let nights = Int(sqlite3_column_int(queryStatement, 2))
                let destination = String(cString: sqlite3_column_text(queryStatement, 3))
                let date = String(cString: sqlite3_column_text(queryStatement, 4))
                let ports = Int(sqlite3_column_int(queryStatement, 5))
                let imageName = String(cString: sqlite3_column_text(queryStatement, 6))

                let cruise = Cruise(name: name, cost: cost, nights: nights, departureDestination: destination, departureDate: date, numPorts: ports, imageName: imageName)
                cruises.append(cruise)
            }
        } else {
            print("SELECT statement could not be prepared")
        }

        sqlite3_finalize(queryStatement)

        return cruises
    }


    deinit {
        if sqlite3_close(db) != SQLITE_OK {
            print("Error closing database")
        }
    }
}
