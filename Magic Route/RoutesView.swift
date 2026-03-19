//
//  RoutesView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/19/26.
//

import SwiftUI
import MapKit

struct BusStop: Identifiable {
    let id = UUID()
    let name: String
    let estimatedTime: String
    let isCompleted: Bool
    let isNext: Bool
    let isParentStop: Bool
}

struct BusRoute: Identifiable {
    let id = UUID()
    let name: String
    let driver: String
    let status: String
    let busNumber: String
    let studentCount: Int
    let notes: String

    let latitude: Double
    let longitude: Double

    let nextStopName: String
    let nextStopETA: String
    let nextStopLatitude: Double
    let nextStopLongitude: Double

    let stops: [BusStop]
}

struct RoutesView: View {
    @State private var selectedFilter = "All"
    @State private var searchText = ""

    let filterOptions = ["All", "On Time", "Delayed", "In Route"]

    let routes = [
        BusRoute(
            name: "Route A",
            driver: "Mike",
            status: "On Time",
            busNumber: "12",
            studentCount: 24,
            notes: "Arriving in 5 minutes",
            latitude: 37.3349,
            longitude: -122.0090,
            nextStopName: "Lincoln Elementary",
            nextStopETA: "3 min",
            nextStopLatitude: 37.3365,
            nextStopLongitude: -122.0050,
            stops: [
                BusStop(name: "Oak Street", estimatedTime: "7:30 AM", isCompleted: true, isNext: false, isParentStop: false),
                BusStop(name: "Pine Avenue", estimatedTime: "7:35 AM", isCompleted: true, isNext: false, isParentStop: false),
                BusStop(name: "Lincoln Elementary", estimatedTime: "7:40 AM", isCompleted: false, isNext: true, isParentStop: true),
                BusStop(name: "Cedar Park", estimatedTime: "7:45 AM", isCompleted: false, isNext: false, isParentStop: false)
            ]
        ),
        BusRoute(
            name: "Route B",
            driver: "Brandi",
            status: "Delayed",
            busNumber: "8",
            studentCount: 19,
            notes: "Traffic is causing a delay",
            latitude: 37.3317,
            longitude: -122.0301,
            nextStopName: "Maple Street Stop",
            nextStopETA: "8 min",
            nextStopLatitude: 37.3295,
            nextStopLongitude: -122.0265,
            stops: [
                BusStop(name: "River Road", estimatedTime: "7:20 AM", isCompleted: true, isNext: false, isParentStop: false),
                BusStop(name: "Maple Street Stop", estimatedTime: "7:28 AM", isCompleted: false, isNext: true, isParentStop: false),
                BusStop(name: "Hillcrest", estimatedTime: "7:34 AM", isCompleted: false, isNext: false, isParentStop: true),
                BusStop(name: "Westview School", estimatedTime: "7:40 AM", isCompleted: false, isNext: false, isParentStop: false)
            ]
        ),
        BusRoute(
            name: "Route C",
            driver: "Paul",
            status: "In Route",
            busNumber: "15",
            studentCount: 31,
            notes: "Currently picking up students",
            latitude: 37.3230,
            longitude: -122.0322,
            nextStopName: "Cedar Park",
            nextStopETA: "5 min",
            nextStopLatitude: 37.3260,
            nextStopLongitude: -122.0280,
            stops: [
                BusStop(name: "North Ridge", estimatedTime: "7:10 AM", isCompleted: true, isNext: false, isParentStop: false),
                BusStop(name: "South Gate", estimatedTime: "7:16 AM", isCompleted: true, isNext: false, isParentStop: false),
                BusStop(name: "Cedar Park", estimatedTime: "7:22 AM", isCompleted: false, isNext: true, isParentStop: false),
                BusStop(name: "Valley Prep", estimatedTime: "7:30 AM", isCompleted: false, isNext: false, isParentStop: true)
            ]
        )
    ]

    var filteredRoutes: [BusRoute] {
        routes.filter { route in
            let matchesFilter = selectedFilter == "All" || route.status == selectedFilter

            let matchesSearch =
                searchText.isEmpty ||
                route.name.localizedCaseInsensitiveContains(searchText) ||
                route.driver.localizedCaseInsensitiveContains(searchText) ||
                route.nextStopName.localizedCaseInsensitiveContains(searchText) ||
                route.stops.contains { $0.name.localizedCaseInsensitiveContains(searchText) }

            return matchesFilter && matchesSearch
        }
    }

    var totalRoutesCount: Int {
        routes.count
    }

    var delayedRoutesCount: Int {
        routes.filter { $0.status == "Delayed" }.count
    }

    var totalStudentsCount: Int {
        routes.reduce(0) { $0 + $1.studentCount }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Today’s Overview")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    HStack(spacing: 12) {
                        StatCardView(
                            title: "Total Routes",
                            value: "\(totalRoutesCount)",
                            systemImage: "bus.fill"
                        )

                        StatCardView(
                            title: "Delayed",
                            value: "\(delayedRoutesCount)",
                            systemImage: "clock.badge.exclamationmark"
                        )

                        StatCardView(
                            title: "Students",
                            value: "\(totalStudentsCount)",
                            systemImage: "person.3.fill"
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.top)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(filterOptions, id: \.self) { filter in
                            Button(action: {
                                selectedFilter = filter
                            }) {
                                Text(filter)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        selectedFilter == filter
                                        ? Color.blue
                                        : Color.gray.opacity(0.15)
                                    )
                                    .foregroundColor(
                                        selectedFilter == filter
                                        ? .white
                                        : .primary
                                    )
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                if filteredRoutes.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)

                        Text("No routes found")
                            .font(.headline)

                        Text("Try a different search or filter.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredRoutes) { route in
                            NavigationLink(destination: RouteDetailView(route: route)) {
                                RouteRowCardView(route: route)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom)
        }
        .navigationTitle("Routes")
        .searchable(text: $searchText, prompt: "Search route, driver, or stop")
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundColor(.blue)

            Text(value)
                .font(.title)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, minHeight: 110, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.12))
        .cornerRadius(16)
    }
}

struct RouteRowCardView: View {
    let route: BusRoute

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(route.name)
                    .font(.headline)

                Text("Driver: \(route.driver)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text("Students: \(route.studentCount)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text("Next Stop: \(route.nextStopName)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Text(route.status)
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(statusColor(for: route.status).opacity(0.2))
                .foregroundColor(statusColor(for: route.status))
                .cornerRadius(10)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(16)
        .shadow(radius: 1)
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

struct StopRowView: View {
    let stop: BusStop

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: stopIcon)
                .foregroundColor(stopColor)
                .font(.title3)

            VStack(alignment: .leading, spacing: 6) {
                Text(stop.name)
                    .font(.headline)

                Text("ETA: \(stop.estimatedTime)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                HStack(spacing: 8) {
                    if stop.isNext {
                        Text("UP NEXT")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.15))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                    }

                    if stop.isParentStop {
                        Text("YOUR STOP")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.purple.opacity(0.15))
                            .foregroundColor(.purple)
                            .cornerRadius(8)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(borderColor, lineWidth: stop.isParentStop ? 1.5 : 0)
        )
    }

    var stopIcon: String {
        if stop.isCompleted {
            return "checkmark.circle.fill"
        } else if stop.isNext {
            return "location.circle.fill"
        } else if stop.isParentStop {
            return "star.circle.fill"
        } else {
            return "circle"
        }
    }

    var stopColor: Color {
        if stop.isCompleted {
            return .green
        } else if stop.isNext {
            return .blue
        } else if stop.isParentStop {
            return .purple
        } else {
            return .gray
        }
    }

    var backgroundColor: Color {
        if stop.isNext && stop.isParentStop {
            return Color.purple.opacity(0.10)
        } else if stop.isNext {
            return Color.blue.opacity(0.08)
        } else if stop.isParentStop {
            return Color.purple.opacity(0.08)
        } else {
            return Color.gray.opacity(0.08)
        }
    }

    var borderColor: Color {
        if stop.isParentStop {
            return .purple.opacity(0.5)
        } else {
            return .clear
        }
    }
}

struct RouteDetailView: View {
    let route: BusRoute

    @State private var position: MapCameraPosition

    init(route: BusRoute) {
        self.route = route

        let centerLatitude = (route.latitude + route.nextStopLatitude) / 2
        let centerLongitude = (route.longitude + route.nextStopLongitude) / 2

        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: centerLatitude,
                longitude: centerLongitude
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.02,
                longitudeDelta: 0.02
            )
        )

        _position = State(initialValue: .region(region))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(route.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Bus Number: \(route.busNumber)")
                    .font(.title3)

                Text("Driver: \(route.driver)")
                    .font(.title3)

                Text("Students on Bus: \(route.studentCount)")
                    .font(.title3)
                    .fontWeight(.semibold)

                Text("Status: \(route.status)")
                    .font(.title3)
                    .foregroundColor(statusColor(for: route.status))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Next Stop")
                        .font(.headline)

                    Text(route.nextStopName)
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text("ETA: \(route.nextStopETA)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.blue.opacity(0.08))
                .cornerRadius(12)

                if let parentStop = route.stops.first(where: { $0.isParentStop }) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Parent View")
                            .font(.headline)

                        Text("Your Stop: \(parentStop.name)")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text("ETA: \(parentStop.estimatedTime)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.purple.opacity(0.08))
                    .cornerRadius(12)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Route Stops")
                        .font(.headline)

                    ForEach(route.stops) { stop in
                        StopRowView(stop: stop)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes")
                        .font(.headline)

                    Text(route.notes)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Bus Location")
                        .font(.headline)

                    Map(position: $position) {
                        Marker(
                            "Bus: \(route.name)",
                            coordinate: CLLocationCoordinate2D(
                                latitude: route.latitude,
                                longitude: route.longitude
                            )
                        )

                        Marker(
                            "Next Stop: \(route.nextStopName)",
                            coordinate: CLLocationCoordinate2D(
                                latitude: route.nextStopLatitude,
                                longitude: route.nextStopLongitude
                            )
                        )
                    }
                    .frame(height: 280)
                    .cornerRadius(12)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Route Details")
        .navigationBarTitleDisplayMode(.inline)
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
    NavigationStack {
        RoutesView()
    }
}
