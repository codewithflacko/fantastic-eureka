//
//  RoutesListView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/22/26.
//

import SwiftUI

struct RoutesListView: View {
    let routes: [BusRoute]

    init(routes: [BusRoute] = [sampleRoute]) {
        self.routes = routes
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(routes) { route in
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

                                    Text(route.status)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(statusColor(for: route.status).opacity(0.15))
                                        .foregroundColor(statusColor(for: route.status))
                                        .cornerRadius(10)
                                }

                                Divider()

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
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Students")
                                            .font(.caption)
                                            .foregroundColor(.secondary)

                                        Text("\(route.studentsOnBus)/\(route.capacity)")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.primary)
                                    }

                                    Spacer()

                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("Stops")
                                            .font(.caption)
                                            .foregroundColor(.secondary)

                                        Text("\(route.stops.count)")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.primary)
                                    }
                                }

                                ProgressView(value: route.progress)
                                    .progressViewStyle(.linear)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Routes")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "on time":
            return .green
        case "in route":
            return .blue
        case "paused":
            return .orange
        case "arrived":
            return .purple
        default:
            return .gray
        }
    }
}

#Preview {
    RoutesListView()
}
