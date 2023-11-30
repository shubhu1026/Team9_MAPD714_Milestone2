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

    deinit {
        if sqlite3_close(db) != SQLITE_OK {
            print("Error closing database")
        }
    }
}
