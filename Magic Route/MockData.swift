//
//  MockData.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/23/26.
//

import Foundation
import CoreLocation

let parentUser = AppUser(name: "Flacko (Parent)", role: .parent)
let dispatcherUser = AppUser(name: "Dispatcher Mike", role: .dispatcher)
let driverUser = AppUser(name: "Driver Sarah", role: .driver)

let sampleRoute = BusRoute(
    name: "Route 12",
    driver: "Driver Sarah",
    status: "On Time",
    nextStop: "Maple Street",
    eta: "7:45 AM",
    studentsOnBus: 5,
    capacity: 20,
    progress: 0.1,
    stops: [
        Stop(name: "Maple Street", time: "7:45 AM"),
        Stop(name: "Oak Avenue", time: "7:50 AM"),
        Stop(name: "Pine Road", time: "7:55 AM")
    ],
    coordinate: CLLocationCoordinate2D(
        latitude: 33.7490,
        longitude: -84.3880
    )
)

let sampleRoutes: [BusRoute] = [
    sampleRoute,
    BusRoute(
        name: "Route 18",
        driver: "Driver James",
        status: "Delayed",
        nextStop: "Oak Street",
        eta: "8:05 AM",
        studentsOnBus: 11,
        capacity: 24,
        progress: 0.45,
        stops: [
            Stop(name: "Oak Street", time: "8:05 AM"),
            Stop(name: "Hill Drive", time: "8:10 AM"),
            Stop(name: "School", time: "8:20 AM")
        ],
        coordinate: CLLocationCoordinate2D(latitude: 33.1550, longitude: -117.3450)
    ),
    BusRoute(
        name: "Route 22",
        driver: "Driver Alicia",
        status: "Paused",
        nextStop: "Cedar Lane",
        eta: "8:12 AM",
        studentsOnBus: 7,
        capacity: 20,
        progress: 0.35,
        stops: [
            Stop(name: "Cedar Lane", time: "8:12 AM"),
            Stop(name: "Birch Court", time: "8:17 AM"),
            Stop(name: "School", time: "8:25 AM")
        ],
        coordinate: CLLocationCoordinate2D(latitude: 33.1620, longitude: -117.3520)
    ),
    BusRoute(
        name: "Route 30",
        driver: "Driver Nina",
        status: "On Time",
        nextStop: "Palm Ave",
        eta: "7:58 AM",
        studentsOnBus: 15,
        capacity: 28,
        progress: 0.70,
        stops: [
            Stop(name: "Palm Ave", time: "7:58 AM"),
            Stop(name: "School", time: "8:05 AM")
        ],
        coordinate: CLLocationCoordinate2D(latitude: 33.1660, longitude: -117.3400)
    )
]
