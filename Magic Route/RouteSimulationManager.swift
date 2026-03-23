//
//  RouteSimulationManager.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/23/26.
//

import Foundation
import CoreLocation
import Combine

struct BusStopPoint: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let scheduledTime: String
}

struct FleetRoute: Identifiable {
    let id = UUID()
    let busNumber: String
    let driver: String
    let status: String
    let nextStop: String
    let eta: String
}

struct DispatchAlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let timestamp: Date
}

final class RouteSimulationManager: ObservableObject {
    @Published var busNumber: String = "Bus #12"
    @Published var driverName: String = "Sarah Johnson"
    @Published var status: String = "In Route"
    @Published var nextStop: String = "Oak Street"
    @Published var eta: String = "8:15 AM"
    @Published var studentsOnBus: Int = 18
    @Published var capacity: Int = 24
    @Published var progress: Double = 0.0
    @Published var busCoordinate: CLLocationCoordinate2D
    @Published var dispatchAlerts: [DispatchAlertItem] = []
    @Published var isPaused: Bool = false
    @Published var issueReported: Bool = false
    @Published var currentCompletedStopIndex: Int = 0

    let stops: [BusStopPoint]

    let childName: String = "Jayden Farquharson"
    let childStopName: String = "Pine Avenue"
    let childStopIndex: Int = 3

    private var timerCancellable: AnyCancellable?
    private var stationaryTime: TimeInterval = 0
    private let tickInterval: TimeInterval = 5
    private let idleAlertThreshold: TimeInterval = 15

    init() {
        self.stops = [
            BusStopPoint(
                name: "Depot",
                coordinate: CLLocationCoordinate2D(latitude: 32.7157, longitude: -117.1611),
                scheduledTime: "8:00 AM"
            ),
            BusStopPoint(
                name: "Maple Ave",
                coordinate: CLLocationCoordinate2D(latitude: 32.7190, longitude: -117.1580),
                scheduledTime: "8:06 AM"
            ),
            BusStopPoint(
                name: "Oak Street",
                coordinate: CLLocationCoordinate2D(latitude: 32.7222, longitude: -117.1545),
                scheduledTime: "8:10 AM"
            ),
            BusStopPoint(
                name: "Pine Avenue",
                coordinate: CLLocationCoordinate2D(latitude: 32.7260, longitude: -117.1505),
                scheduledTime: "8:15 AM"
            ),
            BusStopPoint(
                name: "Cedar Road",
                coordinate: CLLocationCoordinate2D(latitude: 32.7300, longitude: -117.1460),
                scheduledTime: "8:20 AM"
            ),
            BusStopPoint(
                name: "School Arrival",
                coordinate: CLLocationCoordinate2D(latitude: 32.7345, longitude: -117.1415),
                scheduledTime: "8:28 AM"
            )
        ]

        self.busCoordinate = stops[0].coordinate
        self.nextStop = stops[1].name
        self.eta = stops[1].scheduledTime
        self.progress = 0.0

        startSimulation()
    }

    deinit {
        timerCancellable?.cancel()
    }

    var stopsAwayForChild: Int {
        max(childStopIndex - currentCompletedStopIndex, 0)
    }

    var parentAlertText: String {
        switch stopsAwayForChild {
        case 0:
            if currentCompletedStopIndex >= childStopIndex {
                return "The bus is at or has passed your child’s stop."
            } else {
                return "The bus is arriving now."
            }
        case 1:
            return "The bus is 1 stop away from your child’s stop."
        default:
            return "The bus is \(stopsAwayForChild) stops away from your child’s stop."
        }
    }
    var hasArrivedAtSchool: Bool {
        currentCompletedStopIndex >= stops.count - 1
    }

    var schoolArrivalMessage: String {
        if hasArrivedAtSchool {
            return "\(busNumber) has arrived at school."
        } else {
            return "Bus is still in route to school."
        }
    }

    var liveFleetRoutes: [FleetRoute] {
        [
            FleetRoute(
                busNumber: busNumber,
                driver: driverName,
                status: status,
                nextStop: nextStop,
                eta: eta
            ),
            FleetRoute(
                busNumber: "Bus #8",
                driver: "Mike Brown",
                status: "Delayed",
                nextStop: "Maple Ave",
                eta: "8:22 AM"
            ),
            FleetRoute(
                busNumber: "Bus #5",
                driver: "Tina Smith",
                status: "In Route",
                nextStop: "Cedar Road",
                eta: "8:11 AM"
            ),
            FleetRoute(
                busNumber: "Bus #20",
                driver: "Chris Green",
                status: "On Time",
                nextStop: "School Arrival",
                eta: "8:19 AM"
            )
        ]
    }

    func pauseRoute() {
        isPaused = true
        issueReported = false
        status = "Paused"
        addAlertIfNeeded(
            title: "Route Paused",
            message: "\(busNumber) has been manually paused by the driver."
        )
    }

    func resumeRoute() {
        isPaused = false
        issueReported = false
        stationaryTime = 0

        if currentCompletedStopIndex >= stops.count - 1 {
            status = "Arrived"
        } else {
            status = "In Route"
        }
    }

    func reportIssue() {
        issueReported = true
        isPaused = false
        status = "Delayed"
        addAlertIfNeeded(
            title: "Driver Reported Issue",
            message: "\(busNumber) reported an issue near \(currentStopName)."
        )
    }

    private func startSimulation() {
        timerCancellable = Timer.publish(every: tickInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    private func tick() {
        if status == "Arrived" {
            return
        }

        if isPaused || issueReported {
            stationaryTime += tickInterval

            if stationaryTime >= idleAlertThreshold {
                addAlertIfNeeded(
                    title: "Bus Stationary Too Long",
                    message: "\(busNumber) has not moved for \(Int(idleAlertThreshold)) seconds near \(currentStopName)."
                )

                if issueReported == false {
                    status = "Delayed"
                }
            }

            return
        }

        stationaryTime = 0

        if currentCompletedStopIndex < stops.count - 1 {
            currentCompletedStopIndex += 1
            busCoordinate = stops[currentCompletedStopIndex].coordinate

            let totalSegments = max(stops.count - 1, 1)
            progress = Double(currentCompletedStopIndex) / Double(totalSegments)

            if currentCompletedStopIndex < stops.count - 1 {
                nextStop = stops[currentCompletedStopIndex + 1].name
                eta = stops[currentCompletedStopIndex + 1].scheduledTime
                status = currentCompletedStopIndex >= 1 ? "In Route" : "On Time"
            } else {
                nextStop = "Completed"
                eta = "Arrived"
                status = "Arrived"
                addAlertIfNeeded(
                    title: "Route Completed",
                    message: "\(busNumber) has completed its route."
                )
            }
        }
    }

    private var currentStopName: String {
        stops[min(currentCompletedStopIndex, stops.count - 1)].name
    }

    private func addAlertIfNeeded(title: String, message: String) {
        let exists = dispatchAlerts.contains { $0.title == title && $0.message == message }
        if !exists {
            dispatchAlerts.insert(
                DispatchAlertItem(title: title, message: message, timestamp: Date()),
                at: 0
            )
        }
    }
}

