//
//  RoutesView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/19/26.
//

import SwiftUI
import MapKit

struct BusStop: Identifiable {
    let id = UUID()
    let name: String
    var eta: String
    var studentsWaiting: Int
    var isCompleted: Bool
    var isCurrent: Bool
}

struct BusRoute: Identifiable {
    let id = UUID()
    let name: String
    let driver: String
    var status: String
    var studentsOnBus: Int
    var nextStop: String
    var stops: [BusStop]
    let coordinate: CLLocationCoordinate2D
}
// MARK: - Routes View
struct RoutesView: View {
    
    @State private var routes: [BusRoute] = [
        BusRoute(
            name: "Route A",
            driver: "Mike",
            status: "In Route",
            studentsOnBus: 18,
            nextStop: "Palm Ave & 3rd St",
            stops: [
                BusStop(name: "School Pickup Zone", eta: "Completed", studentsWaiting: 0, isCompleted: true, isCurrent: false),
                BusStop(name: "Ocean View Dr", eta: "Completed", studentsWaiting: 0, isCompleted: true, isCurrent: false),
                BusStop(name: "Palm Ave & 3rd St", eta: "2 min", studentsWaiting: 3, isCompleted: false, isCurrent: true),
                BusStop(name: "7th Ave Station", eta: "6 min", studentsWaiting: 4, isCompleted: false, isCurrent: false),
                BusStop(name: "Bayfront Stop", eta: "10 min", studentsWaiting: 2, isCompleted: false, isCurrent: false)
            ],
            coordinate: CLLocationCoordinate2D(latitude: 32.6781, longitude: -117.1720)
        ),
        
        BusRoute(
            name: "Route B",
            driver: "Brandi",
            status: "On Time",
            studentsOnBus: 11,
            nextStop: "Lincoln Rd",
            stops: [
                BusStop(name: "School Pickup Zone", eta: "Completed", studentsWaiting: 0, isCompleted: true, isCurrent: false),
                BusStop(name: "Lincoln Rd", eta: "3 min", studentsWaiting: 2, isCompleted: false, isCurrent: true),
                BusStop(name: "Market Street", eta: "8 min", studentsWaiting: 5, isCompleted: false, isCurrent: false),
                BusStop(name: "Hilltop Ave", eta: "12 min", studentsWaiting: 1, isCompleted: false, isCurrent: false)
            ],
            coordinate: CLLocationCoordinate2D(latitude: 32.7157, longitude: -117.1611)
        ),
        
        BusRoute(
            name: "Route C",
            driver: "Paul",
            status: "Delayed",
            studentsOnBus: 7,
            nextStop: "Cedar Park",
            stops: [
                BusStop(name: "School Pickup Zone", eta: "Completed", studentsWaiting: 0, isCompleted: true, isCurrent: false),
                BusStop(name: "Maple Street", eta: "Completed", studentsWaiting: 0, isCompleted: true, isCurrent: false),
                BusStop(name: "Cedar Park", eta: "5 min", studentsWaiting: 6, isCompleted: false, isCurrent: true),
                BusStop(name: "Broadway Stop", eta: "11 min", studentsWaiting: 2, isCompleted: false, isCurrent: false)
            ],
            coordinate: CLLocationCoordinate2D(latitude: 32.7353, longitude: -117.1490)
        )
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.blue.opacity(0.12), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Bus Routes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    Text("Track route progress, next stop, and student count.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach($routes) { $route in
                                NavigationLink(destination: RouteDetailView(route: $route)) {
                                    RouteCardView(route: route)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Routes")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Route Card
struct RouteCardView: View {
    let route: BusRoute
    
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(route.name)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(route.status)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(statusColor.opacity(0.15))
                    .foregroundColor(statusColor)
                    .clipShape(Capsule())
            }
            
            Text("Driver: \(route.driver)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack {
                Label("\(route.studentsOnBus) students onboard", systemImage: "person.3.fill")
                    .font(.subheadline)
                
                Spacer()
                
                Label("Next: \(route.nextStop)", systemImage: "mappin.and.ellipse")
                    .font(.subheadline)
            }
            .foregroundColor(.primary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .shadow(radius: 4)
    }
}

#Preview {
    RoutesView()
}
