//
//  DriverPortal.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/23/26.
//

import SwiftUI
import MapKit
import CoreLocation

struct DriverHomeView: View {
    let user: AppUser
    let onLogout: () -> Void

    @EnvironmentObject var routeManager: RouteSimulationManager

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.1581, longitude: -117.3506),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Driver Portal")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Welcome, \(user.name)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Button(action: onLogout) {
                        Text("Logout")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.red.opacity(0.12))
                            .foregroundColor(.red)
                            .cornerRadius(12)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Route summary
                VStack(alignment: .leading, spacing: 12) {
                    Text("Assigned Route")
                        .font(.headline)

                    Text(routeManager.route.name)
                        .font(.title3)
                        .fontWeight(.bold)

                    Text("Driver: \(routeManager.route.driver)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("Status: \(routeManager.route.status)")
                        .font(.subheadline)
                        .foregroundColor(statusColor(for: routeManager.route.status))

                    Text("Next Stop: \(routeManager.route.nextStop)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("ETA: \(routeManager.route.eta)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("Students on Bus: \(routeManager.route.studentsOnBus)/\(routeManager.route.capacity)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    ProgressView(value: routeManager.route.progress)
                        .progressViewStyle(.linear)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)

                // Live map
                VStack(alignment: .leading, spacing: 12) {
                    Text("Live Route Map")
                        .font(.headline)

                    Map(position: .constant(.region(region))) {
                        Marker("Bus", coordinate: region.center)

                        ForEach(routeManager.route.stops) { stop in
                            Marker(stop.name, coordinate: routeManager.route.coordinate)
                        }
                    }
                    .frame(height: 230)
                    .cornerRadius(20)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)

                // Route message
                VStack(alignment: .leading, spacing: 10) {
                    Text("Live Update")
                        .font(.headline)

                    Text(routeManager.routeMessage)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)

                // Stops list
                VStack(alignment: .leading, spacing: 12) {
                    Text("Stops")
                        .font(.headline)

                    ForEach(Array(routeManager.route.stops.enumerated()), id: \.element.id) { index, stop in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(stop.name)
                                    .fontWeight(.semibold)

                                Text(stop.time)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            if index < routeManager.currentStopIndex {
                                Text("Completed")
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color.green.opacity(0.15))
                                    .foregroundColor(.green)
                                    .cornerRadius(10)
                            } else if index == routeManager.currentStopIndex && routeManager.isRunning {
                                Text("Current")
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color.orange.opacity(0.15))
                                    .foregroundColor(.orange)
                                    .cornerRadius(10)
                            } else {
                                Text("Upcoming")
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.15))
                                    .foregroundColor(.gray)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)

                // Controls
                VStack(alignment: .leading, spacing: 12) {
                    Text("Driver Controls")
                        .font(.headline)

                    Button("Start Route") {
                        routeManager.startSimulation()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(14)

                    Button("Pause Route") {
                        routeManager.pauseSimulation()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(14)

                    Button("Resume Route") {
                        routeManager.resumeSimulation()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(14)

                    Button("Reset Route") {
                        routeManager.resetSimulation()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(14)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Driver View")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(routeManager.$busCoordinate) { coordinate in
            region.center = coordinate
        }
        .onReceive(routeManager.$route) { updatedRoute in
            region.center = updatedRoute.coordinate
        }
    }

    private func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "on time":
            return .green
        case "in route":
            return .blue
        case "paused":
            return .yellow
        case "arrived":
            return .purple
        default:
            return .primary
        }
    }
}

#Preview {
    DriverHomeView(
        user: AppUser(name: "Driver Sarah", role: .driver),
        onLogout: {}
    )
    .environmentObject(RouteSimulationManager(route: sampleRoute))
}
