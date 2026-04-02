//
//  Models.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/22/26.
//

import Foundation
import CoreLocation

struct Stop: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let time: String
    let coordinate: CLLocationCoordinate2D

    static func == (lhs: Stop, rhs: Stop) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct BusRoute: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let driver: String

    // NEW child details
    let childName: String
    let grade: String
    let schoolName: String
    let pickupStopName: String

    var status: String
    var nextStop: String
    var eta: String
    var studentsOnBus: Int
    let capacity: Int
    var progress: Double
    let stops: [Stop]
    var coordinate: CLLocationCoordinate2D

    var currentStopIndex: Int = 0
    var issueMessage: String? = nil

    var delayMinutes: Int = 0
    var isPaused: Bool = false
    var hasArrivedAtSchool: Bool = false
    var lastMovementDate: Date = Date()

    var isCompleted: Bool {
        hasArrivedAtSchool
    }

    static func == (lhs: BusRoute, rhs: BusRoute) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
