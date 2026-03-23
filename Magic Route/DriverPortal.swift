//
//  DriverPortal.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/23/26.
//

import SwiftUI

struct DriverHomeView: View {
    let user: AppUser
    let onLogout: () -> Void

    @EnvironmentObject private var routeManager: RouteSimulationManager

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                routeSection
                controlsSection
                safetySection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarBackButtonHidden(true)
    }

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Driver View")
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

    private var routeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Assigned Route")
                .font(.headline)

            Text(routeManager.busNumber)
                .font(.title2)
                .fontWeight(.bold)

            Text("Driver: \(routeManager.driverName)")
                .foregroundColor(.secondary)

            HStack {
                Text("Status")
                    .foregroundColor(.secondary)
                Spacer()
                Text(routeManager.status)
                    .fontWeight(.semibold)
                    .foregroundColor(statusColor(routeManager.status))
            }

            HStack {
                Text("Next Stop")
                    .foregroundColor(.secondary)
                Spacer()
                Text(routeManager.nextStop)
                    .fontWeight(.medium)
            }

            HStack {
                Text("ETA")
                    .foregroundColor(.secondary)
                Spacer()
                Text(routeManager.eta)
                    .fontWeight(.medium)
            }

            ProgressView(value: routeManager.progress)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }

    private var controlsSection: some View {
        VStack(spacing: 12) {
            Text("Driver Controls")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                routeManager.pauseRoute()
            } label: {
                Text("Pause Route")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Button {
                routeManager.resumeRoute()
            } label: {
                Text("Resume Route")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Button {
                routeManager.reportIssue()
            } label: {
                Text("Report Issue")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
    }

    private var safetySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Safety Note")
                .font(.headline)

            Text("For this prototype, route progress updates automatically. Driver interaction should be limited to safe exceptions like pausing the route or reporting an issue while stopped.")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
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
        DriverHomeView(user: driverUser, onLogout: {})
            .environmentObject(RouteSimulationManager())
    }
}
