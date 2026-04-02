//
//  DriverHomeView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/26/26.
//

import SwiftUI

struct DriverHomeView: View {
    @ObservedObject var simulator: RouteSimulationManager
    let driverName: String
    @State private var issueText: String = ""

    private var driverRoutes: [BusRoute] {
        simulator.routes.filter { $0.driver == driverName }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(driverRoutes) { route in
                        VStack(alignment: .leading, spacing: 14) {
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
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(10)
                            }

                            Text("Next Stop: \(route.nextStop)")
                                .font(.subheadline)

                            Text("ETA: \(route.eta)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            ProgressView(value: route.progress)

                            HStack(spacing: 12) {
                                Button(route.isPaused ? "Resume Route" : "Pause Route") {
                                    if route.isPaused {
                                        simulator.resumeRoute(route)
                                    } else {
                                        simulator.pauseRoute(route)
                                    }
                                }
                                .buttonStyle(.borderedProminent)

                                Button("Report Issue") {
                                    simulator.reportIssue(
                                        for: route,
                                        message: issueText.isEmpty ? "Driver reported a route issue." : issueText
                                    )
                                    issueText = ""
                                }
                                .buttonStyle(.bordered)
                            }

                            TextField("Type issue message", text: $issueText)
                                .textFieldStyle(.roundedBorder)

                            if let issue = route.issueMessage {
                                Text("Issue: \(issue)")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Driver Portal")
        }
    }
}
