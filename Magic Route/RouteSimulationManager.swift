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
    @Published var routes: [BusRoute] = []
    
    private var timer: Timer?
    
    init(routes: [BusRoute]) {
        self.routes = routes
    }
    
    func startSimulation() {
        stopSimulation()
        
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.updateRoutes()
        }
    }
    
    func stopSimulation() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateRoutes() {
        for index in routes.indices {
            guard !routes[index].isCompleted else { continue }
            guard !routes[index].isPaused else { continue }
            
            let currentRoute = routes[index]
            
            guard currentRoute.currentStopIndex < currentRoute.stops.count else {
                completeRoute(at: index)
                continue
            }
            
            let targetStop = currentRoute.stops[currentRoute.currentStopIndex]
            let currentCoordinate = currentRoute.coordinate
            let targetCoordinate = targetStop.coordinate
            
            let newCoordinate = moveToward(
                from: currentCoordinate,
                to: targetCoordinate,
                step: 0.002
            )
            
            routes[index].coordinate = newCoordinate
            
            let distance = distanceBetween(newCoordinate, targetCoordinate)
            
            if distance < 0.0015 {
                advanceToNextStop(routeIndex: index)
            } else {
                if routes[index].issueMessage == nil {
                    routes[index].status = "On Time"
                }
                routes[index].eta = "\(max(1, routes[index].stops.count - routes[index].currentStopIndex) * 3) min"
                routes[index].progress = calculateProgress(for: routes[index])
            }
        }
    }
    
    private func advanceToNextStop(routeIndex: Int) {
        guard routeIndex < routes.count else { return }
        
        routes[routeIndex].currentStopIndex += 1
        
        if routes[routeIndex].currentStopIndex < routes[routeIndex].stops.count {
            let next = routes[routeIndex].stops[routes[routeIndex].currentStopIndex]
            routes[routeIndex].nextStop = next.name
            routes[routeIndex].status = routes[routeIndex].issueMessage == nil ? "In Route" : "Delayed"
            routes[routeIndex].progress = calculateProgress(for: routes[routeIndex])
        } else {
            completeRoute(at: routeIndex)
        }
    }
    
    private func completeRoute(at index: Int) {
        routes[index].isCompleted = true
        routes[index].hasArrivedAtSchool = true
        routes[index].isPaused = false
        routes[index].issueMessage = nil
        routes[index].status = "Completed"
        routes[index].nextStop = "Arrived at School"
        routes[index].eta = "Arrived"
        routes[index].progress = 1.0
    }
    
    private func calculateProgress(for route: BusRoute) -> Double {
        guard !route.stops.isEmpty else { return 0.0 }
        return min(Double(route.currentStopIndex) / Double(route.stops.count), 1.0)
    }
    
    private func moveToward(
        from: CLLocationCoordinate2D,
        to: CLLocationCoordinate2D,
        step: Double
    ) -> CLLocationCoordinate2D {
        let latDiff = to.latitude - from.latitude
        let lonDiff = to.longitude - from.longitude
        
        let distance = sqrt((latDiff * latDiff) + (lonDiff * lonDiff))
        
        guard distance > step else { return to }
        
        let ratio = step / distance
        
        return CLLocationCoordinate2D(
            latitude: from.latitude + (latDiff * ratio),
            longitude: from.longitude + (lonDiff * ratio)
        )
    }
    
    private func distanceBetween(
        _ a: CLLocationCoordinate2D,
        _ b: CLLocationCoordinate2D
    ) -> Double {
        let latDiff = a.latitude - b.latitude
        let lonDiff = a.longitude - b.longitude
        return sqrt((latDiff * latDiff) + (lonDiff * lonDiff))
    }
    
    func stopsAway(for route: BusRoute, childStopName: String) -> Int? {
        guard let childIndex = route.stops.firstIndex(where: { $0.name == childStopName }) else {
            return nil
        }
        
        let remaining = childIndex - route.currentStopIndex
        return max(remaining, 0)
    }
    
    func arrivalMessage(for route: BusRoute, childStopName: String) -> String {
        if route.hasArrivedAtSchool {
            return "Bus has arrived at school"
        }
        
        guard let stopsAway = stopsAway(for: route, childStopName: childStopName) else {
            return "Stop not found"
        }
        
        switch stopsAway {
        case 0:
            return "Bus is at your stop"
        case 1:
            return "1 stop away"
        case 2:
            return "2 stops away"
        case 3:
            return "3 stops away"
        default:
            return "\(stopsAway) stops away"
        }
    }
    
    func childStopIndex(for route: BusRoute, childStopName: String) -> Int? {
        route.stops.firstIndex(where: { $0.name == childStopName })
    }
    
    func hasPickedUpChild(for route: BusRoute, childStopName: String) -> Bool {
        guard let childIndex = childStopIndex(for: route, childStopName: childStopName) else {
            return false
        }
        return route.currentStopIndex > childIndex
    }
    
    func stopsAwayFromChild(for route: BusRoute, childStopName: String) -> Int? {
        guard let childIndex = childStopIndex(for: route, childStopName: childStopName) else {
            return nil
        }
        
        let remaining = childIndex - route.currentStopIndex
        return max(remaining, 0)
    }
    
    func stopsAwayFromSchoolAfterPickup(for route: BusRoute, childStopName: String) -> Int? {
        guard let childIndex = childStopIndex(for: route, childStopName: childStopName) else {
            return nil
        }
        
        let schoolIndex = route.stops.count - 1
        
        guard route.currentStopIndex > childIndex else {
            return nil
        }
        
        let remaining = schoolIndex - route.currentStopIndex
        return max(remaining, 0)
    }
    
    func parentTrackingMessage(for route: BusRoute, childStopName: String) -> String {
        if route.hasArrivedAtSchool {
            return "Your child has arrived at school"
        }
        
        guard let childIndex = childStopIndex(for: route, childStopName: childStopName) else {
            return "Stop not found"
        }
        
        if route.currentStopIndex < childIndex {
            let remaining = childIndex - route.currentStopIndex
            
            switch remaining {
            case 3:
                return "Bus is 3 stops away"
            case 2:
                return "Bus is 2 stops away"
            case 1:
                return "Bus is 1 stop away"
            case 0:
                return "Bus is at your stop"
            default:
                return "Bus is on the way"
            }
        }
        
        if route.currentStopIndex == childIndex {
            return "Bus is at your stop"
        }
        
        let schoolIndex = route.stops.count - 1
        let remainingToSchool = max(schoolIndex - route.currentStopIndex, 0)
        
        switch remainingToSchool {
        case 0:
            return "Your child has arrived at school"
        case 1:
            return "Your child is on the bus — 1 stop away from school"
        default:
            return "Your child is on the bus — \(remainingToSchool) stops away from school"
        }
    }
    
    func pauseRoute(routeID: UUID) {
        guard let index = routes.firstIndex(where: { $0.id == routeID }) else { return }
        routes[index].isPaused = true
        routes[index].status = "Paused"
        routes[index].eta = "Paused"
    }
    
    func resumeRoute(routeID: UUID) {
        guard let index = routes.firstIndex(where: { $0.id == routeID }) else { return }
        routes[index].isPaused = false
        routes[index].status = routes[index].issueMessage == nil ? "In Route" : "Delayed"
        routes[index].eta = "\(max(1, routes[index].stops.count - routes[index].currentStopIndex) * 3) min"
    }
    
    func reportIssue(routeID: UUID, message: String) {
        guard let index = routes.firstIndex(where: { $0.id == routeID }) else { return }
        routes[index].issueMessage = message
        routes[index].status = "Delayed"
        routes[index].eta = "Delayed"
    }
    
    func clearIssue(routeID: UUID) {
        guard let index = routes.firstIndex(where: { $0.id == routeID }) else { return }
        routes[index].issueMessage = nil
        
        if routes[index].isCompleted {
            routes[index].status = "Completed"
        } else if routes[index].isPaused {
            routes[index].status = "Paused"
        } else {
            routes[index].status = "In Route"
            routes[index].eta = "\(max(1, routes[index].stops.count - routes[index].currentStopIndex) * 3) min"
        }
    }
}
