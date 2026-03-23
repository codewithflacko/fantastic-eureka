//
//  User.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/23/26.
//

import Foundation

enum UserRole {
    case parent
    case dispatcher
    case driver
}

struct AppUser: Identifiable {
    let id = UUID()
    let name: String
    let role: UserRole
}
