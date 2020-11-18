//
//  File.swift
//  Intercom
//
//  Created by  Ronit D. on 11/17/20.
//

import Foundation

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        var safe = emailAddress.replacingOccurrences(of: ".", with: "-")
        safe = safe.replacingOccurrences(of: "@", with: "-")
        return safe
    }
    //let profilePicUrl: String
}
