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
    let user: AppUser
    let onLogout: () -> Void

    @EnvironmentObject var routeManager: RouteSimulationManager

    @State private var rideStatus: StudentRideStatus = .waiting
    @State private var boardedTime: String? = nil
    @State private var hasArrivedAtSchool = false

    @State private var childName = "Jordan Farquharson"
    @State private var assignedStop = "Pine Avenue"
    @State private var pickupStop = "Pine Avenue"

    @State private var busStatus = "In Route"
    @State private var nextStop = "Pine Avenue"
    @State private var stopsAway = 3

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.1581, longitude: -117.3506),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )

    private var rideStatusTitle: String {
        switch rideStatus {
        case .waiting:
            return "Waiting"
        case .boarded:
            return "On Bus"
        case .arrivedAtSchool:
            return "Arrived at School"
        case .absent:
            return "Absent"
        }
    }

    private var rideStatusColor: Color {
        switch rideStatus {
        case .waiting:
            return .orange
        case .boarded:
            return .green
        case .arrivedAtSchool:
            return .blue
        case .absent:
            return .red
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Parent Dashboard")
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

                    Text("Track your child’s bus ride in real time.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Student profile card
                VStack(alignment: .leading, spacing: 16) {
                    Text("Student Profile")
                        .font(.headline)

                    HStack(spacing: 16) {
                        Image("child_profile")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 78, height: 78)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.blue.opacity(0.2), lineWidth: 2)
                            )

                        VStack(alignment: .leading, spacing: 6) {
                            Text(childName)
                                .font(.title3)
                                .fontWeight(.bold)

                            Text("Assigned Stop: \(assignedStop)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Text("Pickup Stop: \(pickupStop)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        Spacer()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)

                // Boarding status card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Boarding Status")
                        .font(.headline)

                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(rideStatusTitle)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(rideStatusColor)

                            if rideStatus == .boarded {
                                Text("Driver confirmed pickup")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                if let boardedTime = boardedTime {
                                    Text("Boarded at \(boardedTime)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }

                                Text("Picked up from \(pickupStop)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                            } else if rideStatus == .absent {
                                Text("Marked absent for this stop")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                            } else if rideStatus == .arrivedAtSchool {
                                Text("Your child has arrived at school.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                            } else {
                                Text("Waiting to be picked up at \(assignedStop)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }

                        Spacer()

                        Text(rideStatus.rawValue)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(rideStatusColor.opacity(0.15))
                            .foregroundColor(rideStatusColor)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)

                // Bus map
                VStack(alignment: .leading, spacing: 12) {
                    Text("Live Bus Location")
                        .font(.headline)

                    Map(position: .constant(.region(region))) {
                        Marker("Bus", coordinate: region.center)
                        Marker(
                            "Stop",
                            coordinate: CLLocationCoordinate2D(
                                latitude: 33.1600,
                                longitude: -117.3480
                            )
                        )
                    }
                    .frame(height: 230)
                    .cornerRadius(20)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)

                // Bus status card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Bus Status")
                        .font(.headline)

                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(busStatus)
                                .font(.title3)
                                .fontWeight(.bold)

                            Text("Next Stop: \(nextStop)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            if !hasArrivedAtSchool {
                                Text("Stops Away: \(stopsAway)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }

                        Spacer()

                        Image(systemName: "bus.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue.opacity(0.08))
                .cornerRadius(20)

                // Live update card
                VStack(alignment: .leading, spacing: 10) {
                    Text("Live Update")
                        .font(.headline)

                    if hasArrivedAtSchool {
                        Text("The bus has arrived at school.")
                            .font(.subheadline)
                            .foregroundColor(.green)

                    } else if rideStatus == .boarded {
                        if let boardedTime = boardedTime {
                            Text("\(childName) is on the bus and boarded at \(boardedTime).")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        } else {
                            Text("\(childName) is on the bus.")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }

                    } else if rideStatus == .absent {
                        Text("\(childName) was marked absent for pickup.")
                            .font(.subheadline)
                            .foregroundColor(.red)

                    } else if stopsAway <= 3 {
                        Text("The bus is \(stopsAway) stop\(stopsAway == 1 ? "" : "s") away from \(assignedStop).")
                            .font(.subheadline)
                            .foregroundColor(.orange)

                    } else {
                        Text("The bus is on the way to \(assignedStop).")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)

                // Demo controls
                VStack(alignment: .leading, spacing: 12) {
                    Text("Demo Controls")
                        .font(.headline)

                    Button("Mark Child Boarded") {
                        rideStatus = .boarded
                        boardedTime = currentTimeString()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(14)

                    Button("Mark Child Absent") {
                        rideStatus = .absent
                        boardedTime = nil
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(14)

                    Button("Reset Child Status") {
                        rideStatus = .waiting
                        boardedTime = nil
                        hasArrivedAtSchool = false
                        busStatus = "In Route"
                        nextStop = "Pine Avenue"
                        stopsAway = 3
                        region.center = CLLocationCoordinate2D(latitude: 33.1581, longitude: -117.3506)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(14)

                    Button("Move Bus Closer") {
                        if stopsAway > 0 {
                            stopsAway -= 1
                            region.center.latitude += 0.0012
                            region.center.longitude += 0.0010
                        } else {
                            hasArrivedAtSchool = true
                            rideStatus = .arrivedAtSchool
                            busStatus = "Arrived at School"
                            nextStop = "School"
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
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
        .navigationTitle("Parent View")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(routeManager.$childOnBus) { isOnBus in
            if isOnBus {
                rideStatus = .boarded
                boardedTime = currentTimeString()
            }
        }
        .onReceive(routeManager.$showSchoolArrivalNotification) { arrived in
            if arrived {
                hasArrivedAtSchool = true
                rideStatus = .arrivedAtSchool
                busStatus = "Arrived at School"
                nextStop = "School"
                stopsAway = 0
            }
        }
        .onReceive(routeManager.$route) { updatedRoute in
            busStatus = updatedRoute.status
            nextStop = updatedRoute.nextStop
            region.center = updatedRoute.coordinate
        }
    }

    private func currentTimeString() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
}

#Preview {
    ParentHomeView(
        user: AppUser(name: "Taylor Parent", role: .parent),
        onLogout: {}
    )
    .environmentObject(RouteSimulationManager(route: sampleRoute))
}
