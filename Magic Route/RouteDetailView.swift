//
//  RouteDetailView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/20/26.
//

import SwiftUI
import MapKit
import CoreLocation

struct RouteDetailView: View {
    let route: BusRoute

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(route.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Spacer()

                        Text(route.status)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(statusColor.opacity(0.2))
                            .foregroundColor(statusColor)
                            .cornerRadius(14)
                    }

                    Text("Driver: \(route.driver)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 3)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Live Bus Location")
                        .font(.title2)
                        .fontWeight(.bold)

                    Map {
                        Marker(route.name, coordinate: route.coordinate)
                    }
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 3)

                VStack(alignment: .leading, spacing: 16) {
                    Text("Live Route Info")
                        .font(.title2)
                        .fontWeight(.bold)

                    HStack {
                        InfoCard(title: "Next Stop", value: route.nextStop, systemImage: "mappin.and.ellipse")
                        InfoCard(title: "ETA", value: route.eta, systemImage: "clock.fill")
                    }

                    HStack {
                        InfoCard(title: "Students", value: "\(route.studentsOnBus)/\(route.capacity)", systemImage: "person.3.fill")
                        InfoCard(title: "Progress", value: "\(Int(route.progress * 100))%", systemImage: "chart.bar.fill")
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Route Progress")
                            .font(.headline)

                        ProgressView(value: route.progress)
                            .scaleEffect(x: 1, y: 2, anchor: .center)

                        Text("\(Int(route.progress * 100))% completed")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 3)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Upcoming Stops")
                        .font(.title2)
                        .fontWeight(.bold)

                    ForEach(route.stops) { stop in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(stop.name)
                                    .font(.headline)

                                Text(stop.time)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            Image(systemName: stop.name == route.nextStop ? "location.fill" : "circle")
                                .foregroundColor(stop.name == route.nextStop ? .blue : .gray)
                        }
                        .padding()
                        .background(
                            stop.name == route.nextStop
                            ? Color.blue.opacity(0.08)
                            : Color.gray.opacity(0.08)
                        )
                        .cornerRadius(12)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 3)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Route Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    var statusColor: Color {
        switch route.status {
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

struct InfoCard: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundColor(.blue)

            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text(value)
                .font(.headline)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue.opacity(0.08))
        .cornerRadius(14)
    }
}

#Preview {
    RouteDetailView(
        route: BusRoute(
            name: "Route A",
            driver: "Mike Johnson",
            status: "On Time",
            nextStop: "Maple Street",
            eta: "8:12 AM",
            studentsOnBus: 18,
            capacity: 30,
            progress: 0.45,
            stops: [
                Stop(name: "Pine Hill", time: "7:50 AM"),
                Stop(name: "Oak Avenue", time: "8:00 AM"),
                Stop(name: "Maple Street", time: "8:12 AM")
            ],
            coordinate: CLLocationCoordinate2D(latitude: 32.7157, longitude: -117.1611)
        )
            
        )
    
}
