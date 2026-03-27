//
//  Models.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/22/26.
//

import Foundation
import CoreLocation

struct Stop: Identifiable {
    let id = UUID()
    let name: String
    let time: String
    let coordinate: CLLocationCoordinate2D
}

struct BusRoute: Identifiable {
    let id = UUID()
    let name: String
    let driver: String
    var status: String
    var nextStop: String
    var eta: String
    var studentsOnBus: Int
    let capacity: Int
    var progress: Double
    let stops: [Stop]
    var coordinate: CLLocationCoordinate2D
    var currentStopIndex: Int = 0
    var isCompleted: Bool = false
    var hasArrivedAtSchool: Bool = false
    
    // NEW
    var isPaused: Bool = false
    var issueMessage: String? = nil
}
