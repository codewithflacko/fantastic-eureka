//
//  MockData.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/23/26.
//

import Foundation
import CoreLocation

let routeAStops: [Stop] = [
    Stop(
        name: "Maple St Stop",
        time: "7:10 AM",
        coordinate: CLLocationCoordinate2D(latitude: 32.7157, longitude: -117.1611)
    ),
    Stop(
        name: "Pine Ave Stop",
        time: "7:15 AM",
        coordinate: CLLocationCoordinate2D(latitude: 32.7180, longitude: -117.1580)
    ),
    Stop(
        name: "Oak Lane Stop",
        time: "7:20 AM",
        coordinate: CLLocationCoordinate2D(latitude: 32.7195, longitude: -117.1560)
    ),
    Stop(
        name: "Cedar Park Stop",
        time: "7:24 AM",
        coordinate: CLLocationCoordinate2D(latitude: 32.7210, longitude: -117.1525)
    ),
    Stop(
        name: "Lincoln High School",
        time: "7:30 AM",
        coordinate: CLLocationCoordinate2D(latitude: 32.7225, longitude: -117.1500)
    )
]

let routeBStops: [Stop] = [
    Stop(
        name: "Sunset Dr Stop",
        time: "7:05 AM",
        coordinate: CLLocationCoordinate2D(latitude: 32.7105, longitude: -117.1650)
    ),
    Stop(
        name: "Palm Ave Stop",
        time: "7:12 AM",
        coordinate: CLLocationCoordinate2D(latitude: 32.7128, longitude: -117.1622)
    ),
    Stop(
        name: "Harbor Blvd Stop",
        time: "7:18 AM",
        coordinate: CLLocationCoordinate2D(latitude: 32.7148, longitude: -117.1590)
    ),
    Stop(
        name: "Bayview Stop",
        time: "7:23 AM",
        coordinate: CLLocationCoordinate2D(latitude: 32.7170, longitude: -117.1558)
    ),
    Stop(
        name: "Lincoln High School",
        time: "7:30 AM",
        coordinate: CLLocationCoordinate2D(latitude: 32.7225, longitude: -117.1500)
    )
]

let mockRoutes: [BusRoute] = [
    BusRoute(
        name: "Route A",
        driver: "Ms. Taylor",
        status: "On Time",
        nextStop: "Maple St Stop",
        eta: "12 min",
        studentsOnBus: 18,
        capacity: 30,
        progress: 0.2,
        stops: routeAStops,
        coordinate: CLLocationCoordinate2D(latitude: 32.7140, longitude: -117.1630)
    ),
    BusRoute(
        name: "Route B",
        driver: "Mr. Johnson",
        status: "On Time",
        nextStop: "Sunset Dr Stop",
        eta: "10 min",
        studentsOnBus: 22,
        capacity: 35,
        progress: 0.1,
        stops: routeBStops,
        coordinate: CLLocationCoordinate2D(latitude: 32.7090, longitude: -117.1670)
    )
]
