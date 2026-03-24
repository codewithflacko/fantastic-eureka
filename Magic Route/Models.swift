//
//  Models.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/22/26.
//

import Foundation
import CoreLocation

enum StudentRideStatus: String, Codable {
    case waiting = "Waiting"
    case boarded = "Boarded"
    case absent = "Absent"
}

struct Student: Identifiable, Hashable {
    let id = UUID()
    let name: String
    var status: StudentRideStatus = .waiting
    var boardedTime: String? = nil
}

struct Stop: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let time: String
    var students: [Student]

    var expectedCount: Int {
        students.count
    }

    var boardedCount: Int {
        students.filter { $0.status == .boarded }.count
    }

    var absentCount: Int {
        students.filter { $0.status == .absent }.count
    }

    var waitingCount: Int {
        students.filter { $0.status == .waiting }.count
    }
}

struct BusRoute: Identifiable {
    let id = UUID()
    let name: String
    let driver: String
    var status: String
    var stops: [Stop]
    let coordinate: CLLocationCoordinate2D
    var studentsOnBus: Int
    var capacity: Int
    var currentStopIndex: Int = 0

    var nextStop: String {
        if currentStopIndex < stops.count {
            return stops[currentStopIndex].name
        } else {
            return "Arrived at School"
        }
    }

    var eta: String {
        if currentStopIndex < stops.count {
            return stops[currentStopIndex].time
        } else {
            return "Completed"
        }
    }

    var progress: Double {
        guard !stops.isEmpty else { return 0 }
        return Double(currentStopIndex) / Double(stops.count)
    }

    var completedStops: [Stop] {
        Array(stops.prefix(currentStopIndex))
    }
}
