//
//  DispatchPortal.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/23/26.
//

import SwiftUI

struct DispatcherHomeView: View {
    let user: AppUser
    let onLogout: () -> Void

    @State private var selectedFilter: RouteFilter = .all

    private var routes: [BusRoute] {
        sampleRoutes
    }

    private var filteredRoutes: [BusRoute] {
        switch selectedFilter {
        case .all:
            return routes
        case .onTime:
            return routes.filter { $0.status.lowercased() == "on time" }
        case .inRoute:
            return routes.filter { $0.status.lowercased() == "in route" }
        case .paused:
            return routes.filter { $0.status.lowercased() == "paused" }
        case .delayed:
            return routes.filter { $0.status.lowercased() == "delayed" }
        case .arrived:
            return routes.filter {
                $0.status.lowercased() == "arrived" ||
                $0.status.lowercased() == "arrived at school"
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Dispatcher Portal")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Welcome, \(user.name)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text("Monitor all active bus routes")
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

                // Fleet overview
                VStack(alignment: .leading, spacing: 12) {
                    Text("Fleet Overview")
                        .font(.headline)

                    HStack(spacing: 12) {
                        summaryCard(title: "All", count: routes.count, color: .gray)
                        summaryCard(
                            title: "On Time",
                            count: routes.filter { $0.status.lowercased() == "on time" }.count,
                            color: .green
                        )
                        summaryCard(
                            title: "Delayed",
                            count: routes.filter { $0.status.lowercased() == "delayed" }.count,
                            color: .red
                        )
                    }

                    HStack(spacing: 12) {
                        summaryCard(
                            title: "In Route",
                            count: routes.filter { $0.status.lowercased() == "in route" }.count,
                            color: .blue
                        )
                        summaryCard(
                            title: "Paused",
                            count: routes.filter { $0.status.lowercased() == "paused" }.count,
                            color: .yellow
                        )
                        summaryCard(
                            title: "Arrived",
                            count: routes.filter {
                                $0.status.lowercased() == "arrived" ||
                                $0.status.lowercased() == "arrived at school"
                            }.count,
                            color: .purple
                        )
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)

                // Filters
                VStack(alignment: .leading, spacing: 12) {
                    Text("Filters")
                        .font(.headline)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            filterChip(.all, title: "All")
                            filterChip(.onTime, title: "On Time")
                            filterChip(.inRoute, title: "In Route")
                            filterChip(.paused, title: "Paused")
                            filterChip(.delayed, title: "Delayed")
                            filterChip(.arrived, title: "Arrived")
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)

                // Route list
                VStack(alignment: .leading, spacing: 12) {
                    Text("Route Status")
                        .font(.headline)

                    if filteredRoutes.isEmpty {
                        Text("No routes match this filter.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(filteredRoutes) { route in
                            NavigationLink(destination: RouteDetailView(route: route)) {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(route.name)
                                                .font(.title3)
                                                .fontWeight(.bold)
                                                .foregroundColor(.primary)

                                            Text("Driver: \(route.driver)")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }

                                        Spacer()

                                        VStack(alignment: .trailing, spacing: 8) {
                                            Text(route.status)
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 6)
                                                .background(statusColor(for: route.status).opacity(0.15))
                                                .foregroundColor(statusColor(for: route.status))
                                                .cornerRadius(10)

                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }

                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Next Stop")
                                                .font(.caption)
                                                .foregroundColor(.secondary)

                                            Text(route.nextStop)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .foregroundColor(.primary)
                                        }

                                        Spacer()

                                        VStack(alignment: .trailing, spacing: 4) {
                                            Text("ETA")
                                                .font(.caption)
                                                .foregroundColor(.secondary)

                                            Text(route.eta)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .foregroundColor(.primary)
                                        }
                                    }

                                    HStack {
                                        Text("Students: \(route.studentsOnBus)/\(route.capacity)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)

                                        Spacer()

                                        Text("Stops: \(route.stops.count)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }

                                    ProgressView(value: route.progress)
                                        .progressViewStyle(.linear)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(16)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Dispatcher View")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func summaryCard(title: String, count: Int, color: Color) -> some View {
        VStack(spacing: 6) {
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.08))
        .cornerRadius(14)
    }

    private func filterChip(_ filter: RouteFilter, title: String) -> some View {
        Button(action: {
            selectedFilter = filter
        }) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(selectedFilter == filter ? Color.blue : Color.gray.opacity(0.15))
                .foregroundColor(selectedFilter == filter ? .white : .primary)
                .cornerRadius(12)
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
        case "delayed":
            return .red
        case "arrived", "arrived at school":
            return .purple
        default:
            return .gray
        }
    }
}

enum RouteFilter {
    case all
    case onTime
    case inRoute
    case paused
    case delayed
    case arrived
}

#Preview {
    NavigationStack {
        DispatcherHomeView(
            user: AppUser(name: "Dispatcher Mike", role: .dispatcher),
            onLogout: {}
        )
    }
}
