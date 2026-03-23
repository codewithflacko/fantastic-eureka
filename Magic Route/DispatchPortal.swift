//
//  DispatchPortal.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/23/26.
//

import SwiftUI
import MapKit

struct DispatcherHomeView: View {
    let user: AppUser
    let onLogout: () -> Void

    @EnvironmentObject private var routeManager: RouteSimulationManager

    @State private var selectedFilter: RouteFilter = .all
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 32.7157, longitude: -117.1611),
        span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
    )

    enum RouteFilter: String, CaseIterable {
        case all = "All"
        case onTime = "On Time"
        case delayed = "Delayed"
        case inRoute = "In Route"
        case paused = "Paused"
        case arrived = "Arrived"
    }

    var filteredRoutes: [FleetRoute] {
        switch selectedFilter {
        case .all:
            return routeManager.liveFleetRoutes
        case .onTime:
            return routeManager.liveFleetRoutes.filter { $0.status == "On Time" }
        case .delayed:
            return routeManager.liveFleetRoutes.filter { $0.status == "Delayed" }
        case .inRoute:
            return routeManager.liveFleetRoutes.filter { $0.status == "In Route" }
        case .paused:
            return routeManager.liveFleetRoutes.filter { $0.status == "Paused" }
        case .arrived:
            return routeManager.liveFleetRoutes.filter { $0.status == "Arrived" }
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                summarySection
                mapSection
                alertsSection
                filtersSection
                liveRoutesSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarBackButtonHidden(true)
        .onAppear {
            region.center = routeManager.busCoordinate
        }
        .onReceive(routeManager.$busCoordinate) { newCoordinate in
            region.center = newCoordinate
        }
    }

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Dispatcher Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Welcome, \(user.name)")
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button("Switch User") {
                onLogout()
            }
            .font(.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.red.opacity(0.12))
            .cornerRadius(10)
        }
    }

    private var summarySection: some View {
        HStack(spacing: 12) {
            summaryCard(
                title: "Total Routes",
                value: "\(routeManager.liveFleetRoutes.count)",
                color: .blue
            )

            summaryCard(
                title: "Delayed",
                value: "\(routeManager.liveFleetRoutes.filter { $0.status == "Delayed" }.count)",
                color: .red
            )

            summaryCard(
                title: "Active",
                value: "\(routeManager.liveFleetRoutes.filter { $0.status == "In Route" || $0.status == "On Time" }.count)",
                color: .green
            )
        }
    }

    private var mapSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Route Map")
                .font(.headline)

            Map(coordinateRegion: $region)
                .frame(height: 260)
                .cornerRadius(16)
        }
    }

    private var alertsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Dispatch Alerts")
                .font(.headline)

            if routeManager.dispatchAlerts.isEmpty {
                Text("No active alerts")
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(16)
            } else {
                ForEach(routeManager.dispatchAlerts) { alert in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(alert.title)
                            .font(.headline)

                        Text(alert.message)
                            .foregroundColor(.secondary)

                        Text(alert.timestamp.formatted(date: .omitted, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
                }
            }
        }
    }

    private var filtersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Filters")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(RouteFilter.allCases, id: \.self) { filter in
                        Button {
                            selectedFilter = filter
                        } label: {
                            Text(filter.rawValue)
                                .fontWeight(.medium)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(selectedFilter == filter ? Color.blue : Color.gray.opacity(0.15))
                                .foregroundColor(selectedFilter == filter ? .white : .primary)
                                .cornerRadius(12)
                        }
                    }
                }
            }
        }
    }

    private var liveRoutesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Live Route Status")
                .font(.headline)

            ForEach(filteredRoutes) { route in
                dispatcherRouteCard(route: route)
            }
        }
    }

    private func summaryCard(title: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
    }

    private func dispatcherRouteCard(route: FleetRoute) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(route.busNumber)
                    .font(.headline)

                Spacer()

                Text(route.status)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(statusColor(route.status))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(statusColor(route.status).opacity(0.12))
                    .cornerRadius(10)
            }

            Text("Driver: \(route.driver)")
                .foregroundColor(.secondary)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Next Stop")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(route.nextStop)
                        .fontWeight(.medium)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text("ETA")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(route.eta)
                        .fontWeight(.medium)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
    }

    private func statusColor(_ status: String) -> Color {
        switch status {
        case "On Time":
            return .green
        case "Delayed":
            return .red
        case "In Route":
            return .blue
        case "Paused":
            return .yellow
        case "Arrived":
            return .green
        default:
            return .gray
        }
    }
}

#Preview {
    NavigationStack {
        DispatcherHomeView(user: dispatcherUser, onLogout: {})
            .environmentObject(RouteSimulationManager())
    }
}
