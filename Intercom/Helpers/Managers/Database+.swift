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
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { (snapshot) in
            guard (snapshot.value as? String) == nil else {
                completion(true)
                return
            }
        }
        
        print("User is not used, sending false")
        completion(false)
    }
    
    /// Inserts a new user to the Firebase Realtime Database
    public func insertUser(with user: IntercomUser, completion: @escaping ((Bool) -> Void)) {
        database.child(user.safeEmail).setValue([
            "firstName": user.firstName,
            "lastName": user.lastName
        ]) { (error, _) in
            guard error == nil else {
                print("Failed to write database, error: \(error!.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }
}
