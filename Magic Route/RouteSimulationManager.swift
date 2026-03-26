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
    @Published var route: BusRoute
    @Published var busCoordinate: CLLocationCoordinate2D
    @Published var currentStopIndex: Int = 0
    @Published var completedStopIDs: Set<UUID> = []
    @Published var isRunning: Bool = false
    @Published var isPaused: Bool = false
    @Published var childOnBus: Bool = false
    @Published var routeMessage: String = "Bus has not started yet"
    @Published var showSchoolArrivalNotification: Bool = false

    private var timer: Timer?
    private var stopCoordinates: [CLLocationCoordinate2D] = []

    init(route: BusRoute) {
        self.route = route
        self.busCoordinate = route.coordinate
        self.stopCoordinates = RouteSimulationManager.makeStopCoordinates(
            from: route.coordinate,
            stopCount: route.stops.count
        )
    }

    deinit {
        timer?.invalidate()
    }

    func startSimulation() {
        guard !route.stops.isEmpty else { return }
        guard !isRunning else { return }

        isRunning = true
        isPaused = false
        routeMessage = "Bus is now in route"

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { [weak self] _ in
            self?.moveToNextStop()
        }
    }

    func pauseSimulation() {
        guard isRunning else { return }
        isPaused = true
        isRunning = false
        timer?.invalidate()
        routeMessage = "Bus is paused"
        updateRoute(status: "Paused")
    }

    func resumeSimulation() {
        guard !route.stops.isEmpty else { return }
        guard !isRunning else { return }

        isPaused = false
        isRunning = true
        routeMessage = "Bus is moving again"

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { [weak self] _ in
            self?.moveToNextStop()
        }
    }

    func resetSimulation() {
        timer?.invalidate()
        timer = nil

        currentStopIndex = 0
        completedStopIDs.removeAll()
        isRunning = false
        isPaused = false
        childOnBus = false
        showSchoolArrivalNotification = false
        busCoordinate = route.coordinate
        routeMessage = "Bus has not started yet"

        updateRoute(
            status: "On Time",
            nextStop: route.stops.first?.name ?? "School",
            eta: route.stops.first?.time ?? "TBD",
            progress: 0.0
        )
    }

    private func moveToNextStop() {
        guard currentStopIndex < route.stops.count else {
            arriveAtSchool()
            return
        }

        let stop = route.stops[currentStopIndex]

        completedStopIDs.insert(stop.id)
        childOnBus = true
        routeMessage = "Arrived at \(stop.name)"

        if currentStopIndex < stopCoordinates.count {
            busCoordinate = stopCoordinates[currentStopIndex]
        }

        let newProgress = Double(currentStopIndex + 1) / Double(route.stops.count)

        let nextStopName: String
        let nextETA: String

        if currentStopIndex + 1 < route.stops.count {
            nextStopName = route.stops[currentStopIndex + 1].name
            nextETA = route.stops[currentStopIndex + 1].time
        } else {
            nextStopName = "School"
            nextETA = "Arriving soon"
        }

        let simulatedStudents = min(route.capacity, max(1, currentStopIndex + 1))

        updateRoute(
            status: "In Route",
            nextStop: nextStopName,
            eta: nextETA,
            studentsOnBus: simulatedStudents,
            progress: newProgress
        )

        currentStopIndex += 1

        if currentStopIndex >= route.stops.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                self?.arriveAtSchool()
            }
        }
    }

    private func arriveAtSchool() {
        timer?.invalidate()
        timer = nil

        isRunning = false
        isPaused = false
        childOnBus = false
        showSchoolArrivalNotification = true
        routeMessage = "Bus has arrived at school"

        updateRoute(
            status: "Arrived",
            nextStop: "School",
            eta: "Arrived",
            studentsOnBus: route.studentsOnBus,
            progress: 1.0
        )
    }

    private func updateRoute(
        status: String,
        nextStop: String? = nil,
        eta: String? = nil,
        studentsOnBus: Int? = nil,
        progress: Double? = nil
    ) {
        route = BusRoute(
            name: route.name,
            driver: route.driver,
            status: status,
            nextStop: nextStop ?? route.nextStop,
            eta: eta ?? route.eta,
            studentsOnBus: studentsOnBus ?? route.studentsOnBus,
            capacity: route.capacity,
            progress: progress ?? route.progress,
            stops: route.stops,
            coordinate: busCoordinate
        )
    }

    private static func makeStopCoordinates(
        from start: CLLocationCoordinate2D,
        stopCount: Int
    ) -> [CLLocationCoordinate2D] {
        guard stopCount > 0 else { return [] }

        var coordinates: [CLLocationCoordinate2D] = []

        for index in 0..<stopCount {
            let latOffset = 0.002 * Double(index + 1)
            let lonOffset = 0.002 * Double(index + 1)

            let coordinate = CLLocationCoordinate2D(
                latitude: start.latitude + latOffset,
                longitude: start.longitude + lonOffset
            )

            coordinates.append(coordinate)
        }

        return coordinates
    }
}
