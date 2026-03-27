//
//  ParentHomeView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/23/26.
//

import SwiftUI
import MapKit
import CoreLocation

struct ParentHomeView: View {
    @ObservedObject var simulator: RouteSimulationManager
    
    let childName: String = "Jordan"
    let childStopName: String = "Maple St Stop"
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 32.7157, longitude: -117.1611),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    
    var selectedRoute: BusRoute? {
        simulator.routes.first
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let route = selectedRoute {
                        
                        // MARK: - Map
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Live Bus Tracking")
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
                            
                            Map(coordinateRegion: $region, annotationItems: mapItems(for: route)) { item in
                                MapAnnotation(coordinate: item.coordinate) {
                                    VStack(spacing: 4) {
                                        if item.type == .bus {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.blue)
                                                    .frame(width: 38, height: 38)
                                                
                                                Image(systemName: "bus.fill")
                                                    .foregroundColor(.white)
                                            }
                                        } else if item.type == .childStop {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.orange)
                                                    .frame(width: 30, height: 30)
                                                
                                                Image(systemName: "figure.child")
                                                    .foregroundColor(.white)
                                                    .font(.caption)
                                            }
                                        } else {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.green)
                                                    .frame(width: 30, height: 30)
                                                
                                                Image(systemName: "building.2.fill")
                                                    .foregroundColor(.white)
                                                    .font(.caption)
                                            }
                                        }
                                        
                                        Text(item.title)
                                            .font(.caption2)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 3)
                                            .background(.ultraThinMaterial)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .frame(height: 280)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                        .onAppear {
                            updateRegion(for: route)
                        }
                        .onChange(of: route.coordinate.latitude) { _ in
                            updateRegion(for: route)
                        }
                        .onChange(of: route.coordinate.longitude) { _ in
                            updateRegion(for: route)
                        }
                        
                        // MARK: - Child Status
                        VStack(alignment: .leading, spacing: 14) {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color.blue.opacity(0.15))
                                        .frame(width: 58, height: 58)
                                    
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.blue)
                                        .font(.title3)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(childName)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    
                                    Text("Assigned Route: \(route.name)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            
                            Divider()
                            
                            Text(simulator.parentTrackingMessage(for: route, childStopName: childStopName))
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            HStack {
                                Label("Next Stop", systemImage: "mappin.and.ellipse")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(route.nextStop)
                                    .fontWeight(.medium)
                            }
                            
                            HStack {
                                Label("ETA", systemImage: "clock")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(route.eta)
                                    .fontWeight(.medium)
                            }
                            
                            if route.hasArrivedAtSchool {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Your child has arrived safely at school.")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.green)
                                }
                                .padding(.top, 4)
                            } else if simulator.hasPickedUpChild(for: route, childStopName: childStopName) {
                                HStack {
                                    Label("Current Status", systemImage: "bus.fill")
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("Child on board")
                                        .fontWeight(.medium)
                                }
                                
                                HStack {
                                    Label("Next Stop", systemImage: "mappin.and.ellipse")
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(route.nextStop)
                                        .fontWeight(.medium)
                                }
                                
                                HStack {
                                    Label("ETA", systemImage: "clock")
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(route.eta)
                                        .fontWeight(.medium)
                                }
                            } else {
                                HStack {
                                    Label("Next Stop", systemImage: "mappin.and.ellipse")
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(route.nextStop)
                                        .fontWeight(.medium)
                                }
                                
                                HStack {
                                    Label("ETA", systemImage: "clock")
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(route.eta)
                                        .fontWeight(.medium)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                        
                        // MARK: - Progress
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Route Progress")
                                    .font(.headline)
                                
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
                            
                            ProgressView(value: route.progress)
                                .progressViewStyle(.linear)
                            
                            Text("\(Int(route.progress * 100))% complete")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                        
                        // MARK: - Stops
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Route Stops")
                                .font(.headline)
                            
                            ForEach(Array(route.stops.enumerated()), id: \.element.id) { index, stop in
                                HStack(alignment: .top, spacing: 12) {
                                    Circle()
                                        .fill(circleColor(for: index, currentStopIndex: route.currentStopIndex, completed: route.isCompleted))
                                        .frame(width: 12, height: 12)
                                        .padding(.top, 5)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(stop.name)
                                            .fontWeight(index == route.currentStopIndex && !route.isCompleted ? .bold : .regular)
                                        
                                        Text(stop.time)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    if route.isCompleted || index < route.currentStopIndex {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    } else if index == route.currentStopIndex {
                                        Text("Now")
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
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "bus")
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                            
                            Text("No route available")
                                .font(.headline)
                            
                            Text("A bus route will appear here once assigned.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 60)
                    }
                }
                .padding()
            }
            .navigationTitle("Parent")
        }
    }
    
    private func updateRegion(for route: BusRoute) {
        withAnimation {
            region = MKCoordinateRegion(
                center: route.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
        }
    }
    
    private func mapItems(for route: BusRoute) -> [ParentMapItem] {
        var items: [ParentMapItem] = [
            ParentMapItem(
                title: "Bus",
                coordinate: route.coordinate,
                type: .bus
            )
        ]
        
        if let childStop = route.stops.first(where: { $0.name == childStopName }) {
            items.append(
                ParentMapItem(
                    title: "Your Stop",
                    coordinate: childStop.coordinate,
                    type: .childStop
                )
            )
        }
        
        if let school = route.stops.last {
            items.append(
                ParentMapItem(
                    title: "School",
                    coordinate: school.coordinate,
                    type: .school
                )
            )
        }
        
        return items
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

struct ParentMapItem: Identifiable {
    enum ItemType {
        case bus
        case childStop
        case school
    }
    
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D
    let type: ItemType
}

func parentTrackingMessage(for route: BusRoute, childStopName: String) -> String {
    if route.hasArrivedAtSchool {
        return "Your child has arrived at school"
    }
    
    guard let childIndex = route.stops.firstIndex(where: { $0.name == childStopName }) else {
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
