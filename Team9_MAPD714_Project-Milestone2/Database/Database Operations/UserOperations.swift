//
//  UserOperations.swift
//  Team9_MAPD714_Project-Milestone2
//
//  Created by Shubham Patel on 2023-12-11.
//

import Foundation
import SQLite3

extension DatabaseManager {
    // Functions related to user operations (e.g., registerUser, loginUser, getUserInfo, updateUserInfo, etc.)
    // ...
    
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
