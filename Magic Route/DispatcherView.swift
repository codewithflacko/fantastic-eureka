//
//  DispatcherView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/26/26.
//

import SwiftUI
import MapKit

struct DispatcherView: View {
    @ObservedObject var simulator: RouteSimulationManager
    @State private var selectedFilter: DispatchFilter = .all
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 32.7157, longitude: -117.1611),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    private var filteredRoutes: [BusRoute] {
        switch selectedFilter {
        case .all:
            return simulator.routes
        case .onTime:
            return simulator.routes.filter { $0.status == "On Time" || $0.status == "In Route" }
        case .delayed:
            return simulator.routes.filter { $0.status == "Delayed" }
        case .paused:
            return simulator.routes.filter { $0.status == "Paused" }
        case .completed:
            return simulator.routes.filter { $0.status == "Completed" }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    
                    // MARK: - Live Map
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Live Fleet Map")
                                .font(.headline)
                            
                            Spacer()
                            
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(.green)
                                    .frame(width: 8, height: 8)
                                
                                Text("Live")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Map(coordinateRegion: $region, annotationItems: simulator.routes) { route in
                            MapAnnotation(coordinate: route.coordinate) {
                                VStack(spacing: 4) {
                                    ZStack {
                                        Circle()
                                            .fill(mapColor(for: route))
                                            .frame(width: 36, height: 36)
                                        
                                        Image(systemName: "bus.fill")
                                            .foregroundColor(.white)
                                    }
                                    
                                    Text(route.name)
                                        .font(.caption2)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 3)
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .frame(height: 260)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                    
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            dashboardCard(
                                title: "Active",
                                value: "\(simulator.routes.filter { !$0.isCompleted }.count)",
                                systemImage: "bus.fill"
                            )
                            
                            dashboardCard(
                                title: "Completed",
                                value: "\(simulator.routes.filter { $0.isCompleted }.count)",
                                systemImage: "checkmark.circle.fill"
                            )
                        }
                        
                        HStack(spacing: 12) {
                            dashboardCard(
                                title: "On Time",
                                value: "\(simulator.routes.filter { $0.status == "On Time" || $0.status == "In Route" }.count)",
                                systemImage: "clock.fill"
                            )
                            
                            dashboardCard(
                                title: "Students",
                                value: "\(simulator.routes.reduce(0) { $0 + $1.studentsOnBus })",
                                systemImage: "person.3.fill"
                            )
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Filters")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(DispatchFilter.allCases, id: \.self) { filter in
                                    Button {
                                        selectedFilter = filter
                                    } label: {
                                        Text(filter.rawValue)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(selectedFilter == filter ? .white : .blue)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 10)
                                            .background(selectedFilter == filter ? Color.blue : Color.blue.opacity(0.12))
                                            .cornerRadius(14)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Route Tracking")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("\(filteredRoutes.count) shown")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        ForEach(filteredRoutes) { route in
                            VStack(alignment: .leading, spacing: 14) {
                                
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(route.name)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        
                                        Text("Driver: \(route.driver)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(route.status)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(statusBackgroundColor(for: route.status))
                                        .foregroundColor(statusTextColor(for: route.status))
                                        .cornerRadius(12)
                                }
                                
                                if let issue = route.issueMessage {
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.red)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Driver Issue Reported")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.red)
                                            
                                            Text(issue)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.red.opacity(0.08))
                                    .cornerRadius(16)
                                }
                                
                                Divider()
                                
                                HStack(spacing: 14) {
                                    trackingPill(
                                        title: "Next Stop",
                                        value: route.nextStop,
                                        icon: "mappin.and.ellipse"
                                    )
                                    
                                    trackingPill(
                                        title: "ETA",
                                        value: route.eta,
                                        icon: "clock"
                                    )
                                }
                                
                                HStack(spacing: 14) {
                                    trackingPill(
                                        title: "Students",
                                        value: "\(route.studentsOnBus)/\(route.capacity)",
                                        icon: "person.3.fill"
                                    )
                                    
                                    trackingPill(
                                        title: "Current",
                                        value: currentRouteStage(for: route),
                                        icon: "location.fill"
                                    )
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Route Progress")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                        
                                        Text("\(Int(route.progress * 100))%")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    ProgressView(value: route.progress)
                                        .progressViewStyle(.linear)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Stops")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    
                                    ForEach(Array(route.stops.enumerated()), id: \.element.id) { index, stop in
                                        HStack {
                                            Circle()
                                                .fill(circleColor(for: index, currentStopIndex: route.currentStopIndex, completed: route.isCompleted))
                                                .frame(width: 10, height: 10)
                                            
                                            Text(stop.name)
                                                .font(.subheadline)
                                            
                                            Spacer()
                                            
                                            if route.isCompleted || index < route.currentStopIndex {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.green)
                                            } else if index == route.currentStopIndex {
                                                Text("Current")
                                                    .font(.caption)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                    }
                                }
                                
                                if route.hasArrivedAtSchool {
                                    HStack(spacing: 8) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                        Text("Route finished successfully")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.green)
                                    }
                                    .padding(.top, 2)
                                }
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Dispatch")
        }
    }
    
    @ViewBuilder
    private func dashboardCard(title: String, value: String, systemImage: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: systemImage)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
    
    @ViewBuilder
    private func trackingPill(title: String, value: String, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.blue.opacity(0.08))
        .cornerRadius(16)
        .frame(maxWidth: .infinity)
    }
    
    private func currentRouteStage(for route: BusRoute) -> String {
        if route.hasArrivedAtSchool {
            return "At School"
        } else if route.currentStopIndex < route.stops.count {
            return route.stops[route.currentStopIndex].name
        } else {
            return "In Route"
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
    
    private func mapColor(for route: BusRoute) -> Color {
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
}

enum DispatchFilter: String, CaseIterable {
    case all = "All"
    case onTime = "On Time"
    case delayed = "Delayed"
    case paused = "Paused"
    case completed = "Completed"
}
