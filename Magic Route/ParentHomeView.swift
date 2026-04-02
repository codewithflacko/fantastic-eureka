//
//  ParentHomeView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/23/26.
//

import SwiftUI
import MapKit

struct ParentHomeView: View {
    @ObservedObject var simulator: RouteSimulationManager
    @State private var selectedRouteID: UUID?

    private var selectedRoute: BusRoute? {
        guard let selectedRouteID else { return simulator.routes.first }
        return simulator.routes.first(where: { $0.id == selectedRouteID })
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    routePickerSection

                    if let route = selectedRoute {
                        parentMapSection(route: route)
                        routeDetailsCard(route: route)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Parent Portal")
            .onAppear {
                if selectedRouteID == nil {
                    selectedRouteID = simulator.routes.first?.id
                }
                simulator.startSimulation()
            }
            .onDisappear {
                simulator.stopSimulation()
            }
        }
    }

    private var routePickerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Child")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(simulator.routes) { route in
                        Button {
                            selectedRouteID = route.id
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(route.childName)
                                    .font(.subheadline.weight(.semibold))
                                Text(route.name)
                                    .font(.caption)
                                Text(route.status)
                                    .font(.caption2)
                                    .foregroundColor(selectedRouteID == route.id ? .white.opacity(0.9) : .secondary)
                            }
                            .padding()
                            .frame(width: 160, alignment: .leading)
                            .background(selectedRouteID == route.id ? Color.blue : Color(.secondarySystemBackground))
                            .foregroundColor(selectedRouteID == route.id ? .white : .primary)
                            .cornerRadius(16)
                        }
                    }
                }
            }
        }
    }

    private func parentMapSection(route: BusRoute) -> some View {
        Map {
            Annotation(route.name, coordinate: route.coordinate) {
                VStack(spacing: 4) {
                    Image(systemName: "bus.fill")
                        .font(.caption)
                        .padding(8)
                        .background(Color.blue.opacity(0.18))
                        .clipShape(Circle())

                    Text(route.name)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                }
            }

            ForEach(route.stops) { stop in
                Annotation(stop.name, coordinate: stop.coordinate) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                }
            }
        }
        .frame(height: 260)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func routeDetailsCard(route: BusRoute) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(route.childName)
                .font(.title2.bold())

            Text("\(route.grade) • \(route.schoolName)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Divider()

            Text(route.name)
                .font(.title3.bold())

            Text("Current Status: \(route.status)")
                .font(.headline)

            Text(parentTrackingMessage(for: route))
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack {
                Label("Driver: \(route.driver)", systemImage: "person.crop.circle")
                    .font(.caption)

                Spacer()

                Label("Pickup: \(route.pickupStopName)", systemImage: "figure.walk")
                    .font(.caption)
            }

            HStack {
                Label("Next Stop: \(route.nextStop)", systemImage: "mappin.and.ellipse")
                    .font(.caption)

                Spacer()

                Label(route.eta, systemImage: "clock")
                    .font(.caption)
            }

            HStack {
                Label("\(route.studentsOnBus)/\(route.capacity) aboard", systemImage: "person.3.fill")
                    .font(.caption)

                Spacer()

                if route.delayMinutes > 0 {
                    Text("⚠️ \(route.delayMinutes) min delay")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }

            ProgressView(value: route.progress)

            if route.currentStopIndex >= max(route.stops.count - 3, 0) && !route.hasArrivedAtSchool {
                Text("Your bus is about 3 stops away.")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.orange)
            }

            if route.hasArrivedAtSchool {
                Text("Your child has arrived at school.")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }

    private func parentTrackingMessage(for route: BusRoute) -> String {
        if route.hasArrivedAtSchool {
            return "\(route.childName)'s bus has arrived at school."
        } else if route.currentStopIndex >= max(route.stops.count - 3, 0) {
            return "\(route.childName)'s bus is about 3 stops away."
        } else {
            return "\(route.childName)'s bus is currently in route."
        }
    }
}

struct ParentHomeViewScreen: View {
    @StateObject private var simulator = RouteSimulationManager()

    var body: some View {
        ParentHomeView(simulator: simulator)
            .onAppear {
                simulator.startSimulation()
            }
            .onDisappear {
                simulator.stopSimulation()
            }
    }
}
