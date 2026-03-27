//
//  DriverHomeView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/26/26.
//

import SwiftUI

struct DriverHomeView: View {
    @ObservedObject var simulator: RouteSimulationManager
    let route: BusRoute
    
    private var liveRoute: BusRoute {
        simulator.routes.first(where: { $0.id == route.id }) ?? route
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - Live Status Banner
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: bannerIcon(for: liveRoute))
                                .font(.title2)
                                .foregroundColor(bannerColor(for: liveRoute))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(bannerTitle(for: liveRoute))
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Text(bannerSubtitle(for: liveRoute))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .background(bannerColor(for: liveRoute).opacity(0.12))
                    .cornerRadius(20)
                    
                    // MARK: - Header Card
                    VStack(alignment: .leading, spacing: 14) {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Assigned Route")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text(liveRoute.name)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.12))
                                    .frame(width: 56, height: 56)
                                
                                Image(systemName: "steeringwheel")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        HStack {
                            Label("Driver", systemImage: "person.fill")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(liveRoute.driver)
                                .fontWeight(.medium)
                        }
                        
                        HStack {
                            Label("Status", systemImage: "waveform.path.ecg")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(liveRoute.status)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(statusBackgroundColor(for: liveRoute.status))
                                .foregroundColor(statusTextColor(for: liveRoute.status))
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                    
                    // MARK: - Controls
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Driver Controls")
                            .font(.headline)
                        
                        HStack(spacing: 12) {
                            Button {
                                if liveRoute.isPaused {
                                    simulator.resumeRoute(routeID: liveRoute.id)
                                } else {
                                    simulator.pauseRoute(routeID: liveRoute.id)
                                }
                            } label: {
                                HStack {
                                    Image(systemName: liveRoute.isPaused ? "play.fill" : "pause.fill")
                                    Text(liveRoute.isPaused ? "Resume Route" : "Pause Route")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(liveRoute.isPaused ? Color.green : Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                            }
                            
                            Button {
                                simulator.clearIssue(routeID: liveRoute.id)
                            } label: {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                    Text("Clear Issue")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                    
                    // MARK: - Quick Actions
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Quick Actions")
                            .font(.headline)
                        
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                quickActionButton(
                                    title: "Student Not Picked Up",
                                    icon: "person.crop.circle.badge.xmark",
                                    color: .orange
                                ) {
                                    simulator.reportIssue(
                                        routeID: liveRoute.id,
                                        message: "Student was not picked up at the assigned stop."
                                    )
                                }
                                
                                quickActionButton(
                                    title: "Heavy Traffic",
                                    icon: "car.fill",
                                    color: .red
                                ) {
                                    simulator.reportIssue(
                                        routeID: liveRoute.id,
                                        message: "Heavy traffic is affecting the current route."
                                    )
                                }
                            }
                            
                            HStack(spacing: 12) {
                                quickActionButton(
                                    title: "Mechanical Issue",
                                    icon: "wrench.and.screwdriver.fill",
                                    color: .purple
                                ) {
                                    simulator.reportIssue(
                                        routeID: liveRoute.id,
                                        message: "Mechanical issue reported on the vehicle."
                                    )
                                }
                                
                                quickActionButton(
                                    title: "Emergency Stop",
                                    icon: "exclamationmark.octagon.fill",
                                    color: .red
                                ) {
                                    simulator.reportIssue(
                                        routeID: liveRoute.id,
                                        message: "Emergency stop reported. Immediate attention may be needed."
                                    )
                                    simulator.pauseRoute(routeID: liveRoute.id)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                    
                    // MARK: - Issue Card
                    if let issue = liveRoute.issueMessage {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                Text("Current Issue")
                                    .font(.headline)
                            }
                            
                            Text(issue)
                                .font(.subheadline)
                            
                            Text("Dispatch can now see this update.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.red.opacity(0.08))
                        .cornerRadius(20)
                    }
                    
                    // MARK: - Next Stop Card
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Next Stop")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(liveRoute.nextStop)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            HStack {
                                Label("ETA", systemImage: "clock")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(liveRoute.eta)
                                    .fontWeight(.semibold)
                            }
                            
                            HStack {
                                Label("Students", systemImage: "person.3.fill")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("\(liveRoute.studentsOnBus)/\(liveRoute.capacity)")
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        if liveRoute.hasArrivedAtSchool {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Route complete. You have arrived at school.")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green)
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                    
                    // MARK: - Progress Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Route Progress")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("\(Int(liveRoute.progress * 100))%")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        ProgressView(value: liveRoute.progress)
                            .progressViewStyle(.linear)
                        
                        Text(progressText(for: liveRoute))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                    
                    // MARK: - Stops Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Stop List")
                            .font(.headline)
                        
                        ForEach(Array(liveRoute.stops.enumerated()), id: \.element.id) { index, stop in
                            HStack(alignment: .top, spacing: 12) {
                                Circle()
                                    .fill(circleColor(for: index, currentStopIndex: liveRoute.currentStopIndex, completed: liveRoute.isCompleted))
                                    .frame(width: 12, height: 12)
                                    .padding(.top, 5)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(stop.name)
                                        .fontWeight(index == liveRoute.currentStopIndex && !liveRoute.isCompleted ? .bold : .regular)
                                    
                                    Text(stop.time)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                if liveRoute.isCompleted || index < liveRoute.currentStopIndex {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                } else if index == liveRoute.currentStopIndex {
                                    Text("Current")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                }
                .padding()
            }
            .navigationTitle("Driver")
        }
    }
    
    @ViewBuilder
    private func quickActionButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, minHeight: 100, alignment: .topLeading)
            .padding()
            .background(color.opacity(0.10))
            .cornerRadius(18)
        }
    }
    
    private func bannerTitle(for route: BusRoute) -> String {
        if route.hasArrivedAtSchool {
            return "Route Completed"
        } else if route.isPaused {
            return "Route Paused"
        } else if route.issueMessage != nil {
            return "Issue Reported"
        } else {
            return "Route In Progress"
        }
    }
    
    private func bannerSubtitle(for route: BusRoute) -> String {
        if route.hasArrivedAtSchool {
            return "You have arrived at school."
        } else if route.isPaused {
            return "Route is currently paused."
        } else if let issue = route.issueMessage {
            return issue
        } else {
            return "Next stop: \(route.nextStop)"
        }
    }
    
    private func bannerColor(for route: BusRoute) -> Color {
        if route.hasArrivedAtSchool {
            return .green
        } else if route.isPaused {
            return .orange
        } else if route.issueMessage != nil {
            return .red
        } else {
            return .blue
        }
    }
    
    private func bannerIcon(for route: BusRoute) -> String {
        if route.hasArrivedAtSchool {
            return "checkmark.circle.fill"
        } else if route.isPaused {
            return "pause.circle.fill"
        } else if route.issueMessage != nil {
            return "exclamationmark.triangle.fill"
        } else {
            return "steeringwheel"
        }
    }
    
    private func progressText(for route: BusRoute) -> String {
        if route.hasArrivedAtSchool {
            return "Route completed successfully."
        } else if route.isPaused {
            return "Route is paused until resumed."
        } else if route.currentStopIndex < route.stops.count {
            return "Currently approaching \(route.stops[route.currentStopIndex].name)."
        } else {
            return "Route is in progress."
        }
    }
    
    private func statusBackgroundColor(for status: String) -> Color {
        switch status {
        case "Completed":
            return Color.green.opacity(0.15)
        case "Paused":
            return Color.orange.opacity(0.15)
        case "Delayed":
            return Color.red.opacity(0.15)
        default:
            return Color.blue.opacity(0.15)
        }
    }
    
    private func statusTextColor(for status: String) -> Color {
        switch status {
        case "Completed":
            return .green
        case "Paused":
            return .orange
        case "Delayed":
            return .red
        default:
            return .blue
        }
    }
    
    private func circleColor(for index: Int, currentStopIndex: Int, completed: Bool) -> Color {
        if completed {
            return .green
        } else if index < currentStopIndex {
            return .green
        } else if index == currentStopIndex {
            return .blue
        } else {
            return .gray.opacity(0.35)
        }
    }
}
