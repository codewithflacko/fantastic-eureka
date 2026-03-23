//
//  RoutesListView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/22/26.
//

import SwiftUI
import CoreLocation

struct RoutesListView: View {
    let routes: [BusRoute] = [
        BusRoute(
            name: "Route A",
            driver: "Mike Johnson",
            status: "On Time",
            nextStop: "Maple Street",
            eta: "8:12 AM",
            studentsOnBus: 18,
            capacity: 30,
            progress: 0.45,
            stops: [
                Stop(name: "Pine Hill", time: "7:50 AM"),
                Stop(name: "Oak Avenue", time: "8:00 AM"),
                Stop(name: "Maple Street", time: "8:12 AM"),
                Stop(name: "Lincoln Elementary", time: "8:25 AM")
            ],
            coordinate: CLLocationCoordinate2D(latitude: 32.7157, longitude: -117.1611)
        ),
        BusRoute(
            name: "Route B",
            driver: "Brandi Smith",
            status: "Delayed",
            nextStop: "Sunset Blvd",
            eta: "8:20 AM",
            studentsOnBus: 24,
            capacity: 30,
            progress: 0.62,
            stops: [
                Stop(name: "River Road", time: "7:45 AM"),
                Stop(name: "Sunset Blvd", time: "8:20 AM"),
                Stop(name: "Hilltop Lane", time: "8:28 AM"),
                Stop(name: "Northview School", time: "8:40 AM")
            ],
            coordinate: CLLocationCoordinate2D(latitude: 32.7300, longitude: -117.1500)
        ),
        BusRoute(
            name: "Route C",
            driver: "Paul Adams",
            status: "In Route",
            nextStop: "Cedar Park",
            eta: "8:08 AM",
            studentsOnBus: 12,
            capacity: 25,
            progress: 0.30,
            stops: [
                Stop(name: "West End", time: "7:55 AM"),
                Stop(name: "Cedar Park", time: "8:08 AM"),
                Stop(name: "Lake Drive", time: "8:15 AM"),
                Stop(name: "Central Middle", time: "8:30 AM")
            ],
            coordinate: CLLocationCoordinate2D(latitude: 32.7400, longitude: -117.1700)
        )
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue.opacity(0.15), .white],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "bus.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)

                Text("School Bus Tracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Track routes, stops, and student counts in real time.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                List(routes) { route in
                    NavigationLink(destination: RouteDetailView(route: route)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(route.name)
                                    .font(.headline)

                                Text("Driver: \(route.driver)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                Text("Next Stop: \(route.nextStop)")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }

                            Spacer()

                            Text(route.status)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(statusColor(for: route.status).opacity(0.2))
                                .foregroundColor(statusColor(for: route.status))
                                .cornerRadius(12)
                        }
                        .padding(.vertical, 6)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .padding()
        }
        .navigationTitle("Dashboard")
    }

    func statusColor(for status: String) -> Color {
        switch status {
        case "On Time":
            return .green
        case "Delayed":
            return .red
        case "In Route":
            return .yellow
        default:
            return .gray
        }
    }
}

#Preview {
    RoutesListView()
}
