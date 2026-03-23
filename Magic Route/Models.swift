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
}

struct BusRoute: Identifiable {
    let id = UUID()
    let name: String
    let driver: String
    let status: String
    let nextStop: String
    let eta: String
    let studentsOnBus: Int
    let capacity: Int
    let progress: Double
    let stops: [Stop]
    let coordinate: CLLocationCoordinate2D
}
