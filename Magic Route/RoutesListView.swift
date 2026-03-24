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
                    name: "Cedar Park",
                    time: "7:25 AM",
                    students: [
                        Student(name: "Noah Wilson"),
                        Student(name: "Mia Clark"),
                        Student(name: "Jayden Hall")
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
        ),
        BusRoute(
            name: "Route B",
            driver: "Brandi Smith",
            status: "Delayed",
            stops: [
                Stop(
                    name: "River Road",
                    time: "7:45 AM",
                    students: [
                        Student(name: "Olivia Martin"),
                        Student(name: "Elijah Walker")
                    ]
                ),
                Stop(
                    name: "Sunset Blvd",
                    time: "8:20 AM",
                    students: [
                        Student(name: "Charlotte Young"),
                        Student(name: "Liam Allen")
                    ]
                ),
                Stop(
                    name: "Hilltop Lane",
                    time: "8:28 AM",
                    students: [
                        Student(name: "Harper King")
                    ]
                ),
                Stop(
                    name: "Northview School",
                    time: "8:40 AM",
                    students: []
                )
            ],
            coordinate: CLLocationCoordinate2D(latitude: 32.7300, longitude: -117.1500),
            studentsOnBus: 12,
            capacity: 28
        ),
        BusRoute(
            name: "Route C",
            driver: "Paul Adams",
            status: "In Route",
            stops: [
                Stop(
                    name: "West End",
                    time: "7:55 AM",
                    students: [
                        Student(name: "Amara Scott"),
                        Student(name: "Lucas Green")
                    ]
                ),
                Stop(
                    name: "Cedar Park",
                    time: "8:08 AM",
                    students: [
                        Student(name: "Zoe Baker")
                    ]
                ),
                Stop(
                    name: "Lake Drive",
                    time: "8:15 AM",
                    students: [
                        Student(name: "Ethan Nelson"),
                        Student(name: "Layla Carter")
                    ]
                ),
                Stop(
                    name: "Central Middle",
                    time: "8:30 AM",
                    students: []
                )
            ],
            coordinate: CLLocationCoordinate2D(latitude: 32.7400, longitude: -117.1700),
            studentsOnBus: 12,
            capacity: 38
        )
    
    ]

    var body: some View {
        NavigationStack {
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
