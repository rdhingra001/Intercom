//
//  Database+.swift
//  Intercom
//
//  Created by  Ronit D. on 11/17/20.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
}

// MARK: - Account Management
extension DatabaseManager {
    
    /// Validates the email to make sure it isn't registered with an existing account
    public func emailIsUsed(with email: String, completion: @escaping ((Bool) -> Void)) {
        database.child(email).observeSingleEvent(of: .value) { (snapshot) in
            guard (snapshot.value as? String) != nil else {
                completion(false)
                return
            }
        }
        
        completion(true)
    }
    
    /// Inserts a new user to the Firebase Realtime Database
    public func insertUser(with user: ChatAppUser) {
        database.child(user.emailAddress).setValue([
            "firstName": user.firstName,
            "lastName": user.lastName
        ])
    }
}