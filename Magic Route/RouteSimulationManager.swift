//
//  RouteSimulationManager.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/23/26.
//

import Foundation
import CoreLocation
import Combine

final class RouteSimulationManager: ObservableObject {
    @Published var routes: [BusRoute] = [
        BusRoute(
            name: "Route 12",
            driver: "Ms. Johnson",
            childName: "Maya Thompson",
            grade: "5th Grade",
            schoolName: "Lincoln High School",
            pickupStopName: "Maple St Stop",
            status: "On Time",
            nextStop: "Maple St Stop",
            eta: "6 mins",
            studentsOnBus: 18,
            capacity: 30,
            progress: 0.12,
            stops: [
                Stop(name: "Maple St Stop", time: "7:10 AM", coordinate: CLLocationCoordinate2D(latitude: 32.7157, longitude: -117.1611)),
                Stop(name: "Pine Ave Stop", time: "7:15 AM", coordinate: CLLocationCoordinate2D(latitude: 32.7180, longitude: -117.1580)),
                Stop(name: "Oak Lane Stop", time: "7:20 AM", coordinate: CLLocationCoordinate2D(latitude: 32.7195, longitude: -117.1560)),
                Stop(name: "Cedar Park Stop", time: "7:24 AM", coordinate: CLLocationCoordinate2D(latitude: 32.7210, longitude: -117.1525)),
                Stop(name: "Lincoln High School", time: "7:30 AM", coordinate: CLLocationCoordinate2D(latitude: 32.7225, longitude: -117.1500))
            ],
            coordinate: CLLocationCoordinate2D(latitude: 32.7157, longitude: -117.1611),
            currentStopIndex: 0,
            issueMessage: nil,
            delayMinutes: 0,
            isPaused: false,
            hasArrivedAtSchool: false,
            lastMovementDate: Date()
        ),
        BusRoute(
            name: "Route 8",
            driver: "Mr. Lee",
            childName: "Jordan Banks",
            grade: "3rd Grade",
            schoolName: "Lincoln High School",
            pickupStopName: "Sunset Dr Stop",
            status: "Minor Delay",
            nextStop: "Sunset Dr Stop",
            eta: "9 mins",
            studentsOnBus: 12,
            capacity: 25,
            progress: 0.32,
            stops: [
                Stop(name: "Sunset Dr Stop", time: "7:05 AM", coordinate: CLLocationCoordinate2D(latitude: 32.7250, longitude: -117.1450)),
                Stop(name: "Cedar Park Stop", time: "7:12 AM", coordinate: CLLocationCoordinate2D(latitude: 32.7270, longitude: -117.1420)),
                Stop(name: "Lake View Stop", time: "7:18 AM", coordinate: CLLocationCoordinate2D(latitude: 32.7290, longitude: -117.1390)),
                Stop(name: "Lincoln High School", time: "7:28 AM", coordinate: CLLocationCoordinate2D(latitude: 32.7225, longitude: -117.1500))
            ],
            coordinate: CLLocationCoordinate2D(latitude: 32.7270, longitude: -117.1420),
            currentStopIndex: 1,
            issueMessage: "Traffic delay reported near Cedar Park Stop",
            delayMinutes: 6,
            isPaused: false,
            hasArrivedAtSchool: false,
            lastMovementDate: Date()
        ),
        BusRoute(
            name: "Route 21",
            driver: "Ms. Carter",
            childName: "Avery Collins",
            grade: "2nd Grade",
            schoolName: "Lincoln High School",
            pickupStopName: "Palm Ave Stop",
            status: "On Time",
            nextStop: "Palm Ave Stop",
            eta: "7 mins",
            studentsOnBus: 20,
            capacity: 32,
            progress: 0.18,
            stops: [
                Stop(name: "Palm Ave Stop", time: "7:00 AM", coordinate: CLLocationCoordinate2D(latitude: 32.7330, longitude: -117.1700)),
                Stop(name: "Broadway Stop", time: "7:07 AM", coordinate: CLLocationCoordinate2D(latitude: 32.7310, longitude: -117.1660)),
                Stop(name: "Harbor View Stop", time: "7:15 AM", coordinate: CLLocationCoordinate2D(latitude: 32.7280, longitude: -117.1600)),
                Stop(name: "Lincoln High School", time: "7:27 AM", coordinate: CLLocationCoordinate2D(latitude: 32.7225, longitude: -117.1500))
            ],
            coordinate: CLLocationCoordinate2D(latitude: 32.7330, longitude: -117.1700),
            currentStopIndex: 0,
            issueMessage: nil,
            delayMinutes: 0,
            isPaused: false,
            hasArrivedAtSchool: false,
            lastMovementDate: Date()
        ),
        BusRoute(
            name: "Route 5",
            driver: "Mr. Brooks",
            childName: "Noah Reed",
            grade: "4th Grade",
            schoolName: "Lincoln High School",
            pickupStopName: "Elm St Stop",
            status: "Paused",
            nextStop: "Elm St Stop",
            eta: "11 mins",
            studentsOnBus: 9,
            capacity: 22,
            progress: 0.45,
            stops: [
                Stop(name: "Elm St Stop", time: "7:03 AM", coordinate: CLLocationCoordinate2D(latitude: 32.7090, longitude: -117.1510)),
                Stop(name: "Juniper Stop", time: "7:09 AM", coordinate: CLLocationCoordinate2D(latitude: 32.7120, longitude: -117.1490)),
                Stop(name: "Market Stop", time: "7:16 AM", coordinate: CLLocationCoordinate2D(latitude: 32.7160, longitude: -117.1470)),
                Stop(name: "Lincoln High School", time: "7:26 AM", coordinate: CLLocationCoordinate2D(latitude: 32.7225, longitude: -117.1500))
            ],
            coordinate: CLLocationCoordinate2D(latitude: 32.7120, longitude: -117.1490),
            currentStopIndex: 1,
            issueMessage: "Temporary stop due to road congestion.",
            delayMinutes: 4,
            isPaused: true,
            hasArrivedAtSchool: false,
            lastMovementDate: Date()
        )
    ]

    private var timer: Timer?

    func startSimulation() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { [weak self] _ in
            self?.updateRoutes()
        }
    }

    func stopSimulation() {
        timer?.invalidate()
        timer = nil
    }

    func pauseRoute(_ route: BusRoute) {
        guard let index = routes.firstIndex(where: { $0.id == route.id }) else { return }
        routes[index].isPaused = true
        routes[index].status = "Paused"
        routes[index].issueMessage = "Route manually paused by driver."
    }

    func resumeRoute(_ route: BusRoute) {
        guard let index = routes.firstIndex(where: { $0.id == route.id }) else { return }
        routes[index].isPaused = false

        if routes[index].delayMinutes >= 10 {
            routes[index].status = "Major Delay"
        } else if routes[index].delayMinutes >= 5 {
            routes[index].status = "Minor Delay"
        } else {
            routes[index].status = "On Time"
        }

        if routes[index].delayMinutes == 0 {
            routes[index].issueMessage = nil
        }
    }

    func reportIssue(for route: BusRoute, message: String) {
        guard let index = routes.firstIndex(where: { $0.id == route.id }) else { return }
        routes[index].issueMessage = message
        routes[index].status = "Major Delay"
        routes[index].delayMinutes += 5
    }

    private func updateRoutes() {
        for index in routes.indices {
            guard !routes[index].hasArrivedAtSchool else { continue }
            if routes[index].isPaused { continue }

            let randomDelayEvent = Int.random(in: 0...18) == 3
            if randomDelayEvent {
                routes[index].delayMinutes += 1
            }

            routes[index].lastMovementDate = Date()
            routes[index].progress += Double.random(in: 0.03...0.06)

            let stopCount = routes[index].stops.count

            if routes[index].progress >= 1.0 {
                routes[index].progress = 1.0
                routes[index].status = "Arrived"
                routes[index].eta = "At School"
                routes[index].nextStop = "School"
                routes[index].hasArrivedAtSchool = true
                routes[index].currentStopIndex = max(stopCount - 1, 0)

                if stopCount > 0 {
                    routes[index].coordinate = routes[index].stops[stopCount - 1].coordinate
                }

                routes[index].issueMessage = nil
                continue
            }

            if routes[index].delayMinutes >= 10 {
                routes[index].status = "Major Delay"
            } else if routes[index].delayMinutes >= 5 {
                routes[index].status = "Minor Delay"
            } else {
                routes[index].status = "On Time"
            }

            if stopCount > 0 {
                let calculatedIndex = min(
                    Int(routes[index].progress * Double(stopCount - 1)),
                    stopCount - 1
                )

                routes[index].currentStopIndex = calculatedIndex
                routes[index].nextStop = routes[index].stops[calculatedIndex].name
                routes[index].coordinate = routes[index].stops[calculatedIndex].coordinate
            }

            let remainingStops = max(1, stopCount - routes[index].currentStopIndex - 1)
            routes[index].eta = "\(remainingStops * 3) mins"

            if routes[index].delayMinutes > 0 && routes[index].status != "On Time" {
                if routes[index].issueMessage == nil || routes[index].issueMessage == "Running behind schedule." {
                    routes[index].issueMessage = "Running behind schedule."
                }
            } else if routes[index].status == "On Time" {
                routes[index].issueMessage = nil
            }
        }
    }
}
