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
    @State private var selectedFilter: RouteFilter = .all

    enum RouteFilter: String, CaseIterable {
        case all = "All"
        case onTime = "On Time"
        case minorDelay = "Minor Delay"
        case majorDelay = "Major Delay"
        case paused = "Paused"
        case arrived = "Arrived"
    }

    private var filteredRoutes: [BusRoute] {
        switch selectedFilter {
        case .all:
            return simulator.routes
        case .onTime:
            return simulator.routes.filter { $0.status == "On Time" }
        case .minorDelay:
            return simulator.routes.filter { $0.status == "Minor Delay" }
        case .majorDelay:
            return simulator.routes.filter { $0.status == "Major Delay" }
        case .paused:
            return simulator.routes.filter { $0.status == "Paused" }
        case .arrived:
            return simulator.routes.filter { $0.status == "Arrived" }
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                mapSection
                dashboardSection
                filterSection
                routesSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Dispatcher Dashboard")
                .font(.largeTitle.bold())

            Text("Monitor all active routes, delays, and driver-reported issues.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var mapSection: some View {
        Map {
            ForEach(simulator.routes) { route in
                Annotation(route.name, coordinate: route.coordinate) {
                    VStack(spacing: 4) {
                        Image(systemName: "bus.fill")
                            .font(.caption)
                            .padding(8)
                            .background(statusBackgroundColor(for: route.status))
                            .clipShape(Circle())

                        Text(route.name)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .frame(height: 260)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var dashboardSection: some View {
        HStack(spacing: 12) {
            dashboardCard(
                title: "Active",
                value: "\(simulator.routes.filter { !$0.hasArrivedAtSchool }.count)",
                systemImage: "bus.fill"
            )

            dashboardCard(
                title: "Completed",
                value: "\(simulator.routes.filter { $0.hasArrivedAtSchool }.count)",
                systemImage: "checkmark.circle.fill"
            )

            dashboardCard(
                title: "Issues",
                value: "\(simulator.routes.filter { $0.issueMessage != nil }.count)",
                systemImage: "exclamationmark.triangle.fill"
            )
        }
    }

    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(RouteFilter.allCases, id: \.self) { filter in
                    Button {
                        selectedFilter = filter
                    } label: {
                        Text(filter.rawValue)
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(selectedFilter == filter ? Color.blue : Color(.secondarySystemBackground))
                            .foregroundColor(selectedFilter == filter ? .white : .primary)
                            .cornerRadius(14)
                    }
                }
            }
            .padding(.horizontal, 1)
        }
    }

    private var routesSection: some View {
        LazyVStack(spacing: 16) {
            ForEach(filteredRoutes) { route in
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(route.name)
                                    .font(.headline)

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

                        HStack {
                            Text("Next: \(route.nextStop)")
                                .font(.caption)

                            Spacer()

                            Text("ETA: \(route.eta)")
                                .font(.caption)
                        }

                        HStack {
                            Text("Students: \(route.studentsOnBus)/\(route.capacity)")
                                .font(.caption2)
                                .foregroundColor(.secondary)

                            Spacer()

                            if route.delayMinutes > 0 {
                                Text("⚠️ \(route.delayMinutes) min delay")
                                    .font(.caption2)
                                    .foregroundColor(.orange)
                            }
                        }

                        ProgressView(value: route.progress)
                    }

                    if let issue = route.issueMessage {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Driver Issue Reported")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)

                                Text(issue)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color.red.opacity(0.08))
                        .cornerRadius(14)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
            }
        }
    }

    private func dashboardCard(title: String, value: String, systemImage: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: systemImage)
                .font(.title2)

            Text(value)
                .font(.title.bold())

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 110, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }

    private func statusBackgroundColor(for status: String) -> Color {
        switch status {
        case "On Time":
            return Color.green.opacity(0.15)
        case "Minor Delay":
            return Color.orange.opacity(0.15)
        case "Major Delay":
            return Color.red.opacity(0.15)
        case "Paused":
            return Color.yellow.opacity(0.2)
        case "Arrived":
            return Color.blue.opacity(0.15)
        default:
            return Color.gray.opacity(0.15)
        }
    }

    private func statusTextColor(for status: String) -> Color {
        switch status {
        case "On Time":
            return .green
        case "Minor Delay":
            return .orange
        case "Major Delay":
            return .red
        case "Paused":
            return .yellow
        case "Arrived":
            return .blue
        default:
            return .gray
        }
    }
}
