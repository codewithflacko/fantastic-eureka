//
//  RouteDetailView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/20/26.
//
import SwiftUI
import MapKit
import CoreLocation

struct RouteDetailView: View {
    @State var route: BusRoute
    @State private var hasStartedRoute = false
    @State private var showArrivalBanner = false
    @State private var isPaused = false
    @State private var pausedSeconds = 0
    @State private var simulationTimer: Timer?
    @State private var pauseTimer: Timer?
    @State private var dispatchAlertSent = false

    private var statusColor: Color {
        switch route.status {
        case "On Time":
            return .green
        case "Possible Delay":
            return .orange
        case "Delayed":
            return .red
        case "In Route":
            return .yellow
        case "Completed":
            return .blue
        default:
            return .gray
        }
    }

    private var currentStop: Stop? {
        guard route.currentStopIndex < route.stops.count else { return nil }
        return route.stops[route.currentStopIndex]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(route.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Spacer()

                        Text(route.status)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(statusColor.opacity(0.2))
                            .foregroundColor(statusColor)
                            .cornerRadius(12)
                    }

                    Text("Driver: \(route.driver)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Route Progress")
                        .font(.headline)

                    ProgressView(value: route.progress)
                        .tint(.blue)
                        .scaleEffect(x: 1, y: 2, anchor: .center)

                    Text("\(route.completedStops.count) of \(route.stops.count) stops completed")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Next Stop")
                        .font(.headline)

                    Text(route.nextStop)
                        .font(.title3)
                        .fontWeight(.bold)

                    Text("ETA: \(route.eta)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue.opacity(0.08))
                .cornerRadius(20)

                Map {
                    Marker(route.name, coordinate: route.coordinate)
                }
                .frame(height: 220)
                .cornerRadius(20)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Bus Capacity")
                        .font(.headline)

                    Text("\(route.studentsOnBus) students currently on bus")
                        .font(.title3)
                        .fontWeight(.bold)

                    Text("Capacity: \(route.capacity)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)

                if let stop = currentStop {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Current Stop Students")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(stop.name)
                            .font(.headline)

                        HStack(spacing: 12) {
                            statPill(title: "Expected", value: "\(stop.expectedCount)", color: .blue)
                            statPill(title: "Boarded", value: "\(stop.boardedCount)", color: .green)
                            statPill(title: "Waiting", value: "\(stop.waitingCount)", color: .orange)
                        }

                        if stop.students.isEmpty {
                            Text("No student pickups assigned at this stop.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(Array(stop.students.enumerated()), id: \.element.id) { studentIndex, student in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(student.name)
                                                .font(.headline)

                                            Text(student.status.rawValue)
                                                .font(.subheadline)
                                                .foregroundColor(studentStatusColor(student.status))
                                        }

                                        Spacer()

                                        if let boardedTime = student.boardedTime {
                                            Text(boardedTime)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }

                                    HStack(spacing: 10) {
                                        Button("Boarded") {
                                            markStudentBoarded(studentIndex: studentIndex)
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color.green.opacity(0.15))
                                        .foregroundColor(.green)
                                        .cornerRadius(10)

                                        Button("Absent") {
                                            markStudentAbsent(studentIndex: studentIndex)
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color.red.opacity(0.15))
                                        .foregroundColor(.red)
                                        .cornerRadius(10)

                                        Button("Reset") {
                                            resetStudent(studentIndex: studentIndex)
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color.gray.opacity(0.15))
                                        .foregroundColor(.gray)
                                        .cornerRadius(10)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Simulation Status")
                        .font(.headline)

                    Text(isPaused ? "Bus is paused" : "Bus is moving")
                        .foregroundColor(isPaused ? .orange : .green)

                    if isPaused {
                        Text("Paused for \(pausedSeconds) seconds")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    if dispatchAlertSent {
                        Text("Dispatch Alert Sent")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)

                VStack(spacing: 12) {
                    Button(action: startRoute) {
                        Text(hasStartedRoute ? "Route Running" : "Start Route")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(hasStartedRoute ? Color.gray.opacity(0.25) : Color.blue)
                            .foregroundColor(hasStartedRoute ? .black : .white)
                            .cornerRadius(14)
                    }
                    .disabled(hasStartedRoute)

                    Button(action: togglePauseRoute) {
                        Text(isPaused ? "Resume Route" : "Pause Route")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isPaused ? Color.green : Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                    .disabled(!hasStartedRoute || route.status == "Completed")

                    Button(action: completeNextStopManually) {
                        Text(route.currentStopIndex < route.stops.count ? "Skip to Next Stop" : "Route Complete")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(route.currentStopIndex < route.stops.count ? Color.purple : Color.gray.opacity(0.25))
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                    .disabled(!hasStartedRoute || route.currentStopIndex >= route.stops.count)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Stops")
                        .font(.title2)
                        .fontWeight(.bold)

                    ForEach(Array(route.stops.enumerated()), id: \.element.id) { index, stop in
                        HStack(spacing: 12) {
                            Image(systemName: iconForStop(index: index))
                                .foregroundColor(colorForStop(index: index))
                                .font(.title3)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(stop.name)
                                    .font(.headline)

                                Text(stop.time)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                Text("Expected: \(stop.expectedCount) • Boarded: \(stop.boardedCount)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            Text(labelForStop(index: index))
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(colorForStop(index: index).opacity(0.15))
                                .foregroundColor(colorForStop(index: index))
                                .cornerRadius(10)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                        )
                    }
                }

                if showArrivalBanner {
                    Text("Bus arrived at school")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.15))
                        .foregroundColor(.green)
                        .cornerRadius(14)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Route Details")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            stopAllTimers()
        }
    }

    private func startRoute() {
        hasStartedRoute = true
        isPaused = false
        pausedSeconds = 0
        dispatchAlertSent = false
        route.status = "In Route"
        startSimulationTimer()
    }

    private func togglePauseRoute() {
        if isPaused {
            resumeRoute()
        } else {
            pauseRoute()
        }
    }

    private func pauseRoute() {
        isPaused = true
        simulationTimer?.invalidate()
        simulationTimer = nil
        startPauseTimer()
    }

    private func resumeRoute() {
        isPaused = false
        pausedSeconds = 0
        pauseTimer?.invalidate()
        pauseTimer = nil
        dispatchAlertSent = false

        if route.status != "Completed" {
            route.status = "In Route"
            startSimulationTimer()
        }
    }

    private func startSimulationTimer() {
        simulationTimer?.invalidate()

        simulationTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            guard !isPaused else { return }
            advanceToNextStop()
        }
    }

    private func startPauseTimer() {
        pauseTimer?.invalidate()

        pauseTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            pausedSeconds += 1

            if pausedSeconds >= 5 && pausedSeconds < 10 {
                route.status = "Possible Delay"
            } else if pausedSeconds >= 10 {
                route.status = "Delayed"
            }

            if pausedSeconds >= 15 {
                dispatchAlertSent = true
            }
        }
    }

    private func advanceToNextStop() {
        guard route.currentStopIndex < route.stops.count else {
            finishRoute()
            return
        }

        route.currentStopIndex += 1

        if route.currentStopIndex >= route.stops.count {
            finishRoute()
        } else {
            route.status = "In Route"
        }
    }

    private func completeNextStopManually() {
        advanceToNextStop()
    }

    private func finishRoute() {
        route.status = "Completed"
        showArrivalBanner = true
        stopAllTimers()
    }

    private func stopAllTimers() {
        simulationTimer?.invalidate()
        simulationTimer = nil
        pauseTimer?.invalidate()
        pauseTimer = nil
    }

    private func markStudentBoarded(studentIndex: Int) {
        guard route.currentStopIndex < route.stops.count else { return }

        if route.stops[route.currentStopIndex].students[studentIndex].status != .boarded {
            if route.stops[route.currentStopIndex].students[studentIndex].status != .boarded {
                route.studentsOnBus += 1
            }
        }

        route.stops[route.currentStopIndex].students[studentIndex].status = .boarded
        route.stops[route.currentStopIndex].students[studentIndex].boardedTime = currentTimeString()
    }

    private func markStudentAbsent(studentIndex: Int) {
        guard route.currentStopIndex < route.stops.count else { return }

        let previousStatus = route.stops[route.currentStopIndex].students[studentIndex].status

        route.stops[route.currentStopIndex].students[studentIndex].status = .absent
        route.stops[route.currentStopIndex].students[studentIndex].boardedTime = nil

        if previousStatus == .boarded && route.studentsOnBus > 0 {
            route.studentsOnBus -= 1
        }
    }

    private func resetStudent(studentIndex: Int) {
        guard route.currentStopIndex < route.stops.count else { return }

        let previousStatus = route.stops[route.currentStopIndex].students[studentIndex].status

        route.stops[route.currentStopIndex].students[studentIndex].status = .waiting
        route.stops[route.currentStopIndex].students[studentIndex].boardedTime = nil

        if previousStatus == .boarded && route.studentsOnBus > 0 {
            route.studentsOnBus -= 1
        }
    }

    private func currentTimeString() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }

    private func studentStatusColor(_ status: StudentRideStatus) -> Color {
        switch status {
        case .waiting:
            return .orange
        case .boarded:
            return .green
        case .absent:
            return .red
        }
    }

    private func statPill(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(color.opacity(0.12))
        .foregroundColor(color)
        .cornerRadius(12)
    }

    private func labelForStop(index: Int) -> String {
        if index < route.currentStopIndex {
            return "Completed"
        } else if index == route.currentStopIndex && route.currentStopIndex < route.stops.count {
            return "Next"
        } else {
            return "Upcoming"
        }
    }

    private func colorForStop(index: Int) -> Color {
        if index < route.currentStopIndex {
            return .green
        } else if index == route.currentStopIndex && route.currentStopIndex < route.stops.count {
            return .blue
        } else {
            return .gray
        }
    }

    private func iconForStop(index: Int) -> String {
        if index < route.currentStopIndex {
            return "checkmark.circle.fill"
        } else if index == route.currentStopIndex && route.currentStopIndex < route.stops.count {
            return "location.circle.fill"
        } else {
            return "circle"
        }
    }
}

#Preview {
    NavigationStack {
        RouteDetailView(
            route: BusRoute(
                name: "Route A",
                driver: "Jordan Smith",
                status: "On Time",
                stops: [
                    Stop(
                        name: "Maple Street",
                        time: "7:10 AM",
                        students: [
                            Student(name: "Ava Johnson"),
                            Student(name: "Malik Brown"),
                            Student(name: "Sofia Lee")
                        ]
                    ),
                    Stop(
                        name: "Pine Avenue",
                        time: "7:18 AM",
                        students: [
                            Student(name: "Chris Thomas"),
                            Student(name: "Emma Davis")
                        ]
                    ),
                    Stop(
                        name: "Lincoln High",
                        time: "7:40 AM",
                        students: []
                    )
                ],
                coordinate: CLLocationCoordinate2D(latitude: 33.1581, longitude: -117.3506),
                studentsOnBus: 24,
                capacity: 40
            )
        )
    }
}
