//
//  ParentHomeView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/23/26.
//

import SwiftUI
import MapKit

struct ParentHomeView: View {
    let user: AppUser
    let onLogout: () -> Void

    @EnvironmentObject private var routeManager: RouteSimulationManager

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 32.7157, longitude: -117.1611),
        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    )

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                studentSection
                mapSection
                schoolArrivalSection
                updatesSection
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
                Text("Welcome, \(user.name)")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Parent Portal")
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

    private var studentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Student")
                .font(.headline)

            Text(routeManager.childName)
                .font(.title3)
                .fontWeight(.semibold)

            HStack {
                Label(routeManager.busNumber, systemImage: "bus.fill")
                Spacer()
                Text(routeManager.status)
                    .fontWeight(.semibold)
                    .foregroundColor(statusColor(routeManager.status))
            }

            Divider()

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Next Stop")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(routeManager.nextStop)
                        .fontWeight(.semibold)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 6) {
                    Text("ETA")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(routeManager.eta)
                        .fontWeight(.semibold)
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Parent Alert")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(routeManager.parentAlertText)
                    .font(.headline)
                    .foregroundColor(.blue)
            }

            ProgressView(value: routeManager.progress)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
    }

    private var mapSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Live Map")
                .font(.headline)

            Map(coordinateRegion: $region)
                .frame(height: 260)
                .cornerRadius(16)

            Text("Parents only see tracking related to their assigned student.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private var schoolArrivalSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("School Arrival")
                .font(.headline)

            HStack(alignment: .top, spacing: 12) {
                Image(systemName: routeManager.hasArrivedAtSchool ? "checkmark.circle.fill" : "clock.fill")
                    .font(.title2)
                    .foregroundColor(routeManager.hasArrivedAtSchool ? .green : .orange)

                VStack(alignment: .leading, spacing: 6) {
                    Text(routeManager.hasArrivedAtSchool ? "Arrived at School" : "En Route to School")
                        .font(.headline)

                    Text(routeManager.schoolArrivalMessage)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
        }
    }

    private var updatesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Route Updates")
                .font(.headline)

            updateRow(title: "Current Status", value: routeManager.status)
            updateRow(title: "Your Stop", value: routeManager.childStopName)
            updateRow(title: "Stops Away", value: "\(routeManager.stopsAwayForChild)")
        }
    }

    private func updateRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
    }

    private func statusColor(_ status: String) -> Color {
        switch status {
        case "On Time":
            return .green
        case "Delayed":
            return .orange
        case "In Route":
            return .blue
        case "Paused":
            return .orange
        case "Arrived":
            return .green
        default:
            return .gray
        }
    }
}

#Preview {
    NavigationStack {
        ParentHomeView(user: parentUser, onLogout: {})
            .environmentObject(RouteSimulationManager())
    }
}
