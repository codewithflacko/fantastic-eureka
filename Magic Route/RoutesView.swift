//
//  RoutesView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/19/26.
//

import SwiftUI
import MapKit

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
            nextStopLongitude: -122.0050
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
            nextStopLongitude: -122.0265
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
            nextStopLongitude: -122.0280
        )
    ]

    var filteredRoutes: [BusRoute] {
        routes.filter { route in
            let matchesFilter = selectedFilter == "All" || route.status == selectedFilter

            let matchesSearch =
                searchText.isEmpty ||
                route.name.localizedCaseInsensitiveContains(searchText) ||
                route.driver.localizedCaseInsensitiveContains(searchText) ||
                route.nextStopName.localizedCaseInsensitiveContains(searchText)

            return matchesFilter && matchesSearch
        }
    }

    var body: some View {
        VStack(spacing: 0) {
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
                .padding(.top)
                .padding(.bottom, 8)
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(filteredRoutes) { route in
                    NavigationLink(destination: RouteDetailView(route: route)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
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
                                .padding(8)
                                .background(statusColor(for: route.status).opacity(0.2))
                                .foregroundColor(statusColor(for: route.status))
                                .cornerRadius(8)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Routes")
        .searchable(text: $searchText, prompt: "Search route, driver, or stop")
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
