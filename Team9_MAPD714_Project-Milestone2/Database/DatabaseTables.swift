//
//  DatabaseTables.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-11-29.
//

import Foundation
import SQLite3

extension DatabaseManager {
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
                country TEXT,
                phone_number TEXT
            );
        """

        let createCruisesTable = """
            CREATE TABLE IF NOT EXISTS Cruises (
                cruise_id INTEGER PRIMARY KEY AUTOINCREMENT,
                cruise_name TEXT NOT NULL,
                cruise_cost INTEGER,
                cruise_length_nights INTEGER,
                operator_name TEXT,
                trip_from TEXT,
                trip_to TEXT,
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
                date DATE,
                port_image TEXT
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
}
