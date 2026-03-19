//
//  ContentView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/18/26.
//

import SwiftUI
import MapKit

// MARK: - Model
struct BusRoute: Identifiable {
    let id = UUID()
    let name: String
    let driver: String
    let status: String
    let pickupTime: String
    let latitude: Double
    let longitude: Double
}

// MARK: - Status Color Helper
func statusColor(_ status: String) -> Color {
    switch status {
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

// MARK: - Main Screen
struct ContentView: View {
    
    let routes = [
        BusRoute(
            name: "Route A",
            driver: "Mike",
            status: "On Time",
            pickupTime: "7:15 AM",
            latitude: 32.7157,
            longitude: -117.1611
        ),
        BusRoute(
            name: "Route B",
            driver: "Brandi",
            status: "Delayed",
            pickupTime: "7:30 AM",
            latitude: 32.7353,
            longitude: -117.1490
        ),
        BusRoute(
            name: "Route C",
            driver: "Paul",
            status: "In Route",
            pickupTime: "7:45 AM",
            latitude: 32.7066,
            longitude: -117.1570
        )
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue.opacity(0.1)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    Image(systemName: "bus.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.blue)
                    
                    Text("Welcome to School Transport")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Select a bus route to view driver details, status, pickup time, and route location.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("School Bus Routes")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    List(routes) { route in
                        NavigationLink(destination: RouteDetailView(route: route)) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(route.name)
                                    .font(.headline)
                                
                                HStack {
                                    Circle()
                                        .fill(statusColor(route.status))
                                        .frame(width: 10, height: 10)
                                    
                                    Text(route.status)
                                        .font(.subheadline)
                                        .foregroundStyle(statusColor(route.status))
                                }
                                
                                Text("Driver: \(route.driver)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
                .padding()
            }
        }
    }
}

// MARK: - Detail Screen
struct RouteDetailView: View {
    let route: BusRoute
    
    var body: some View {
        let routeCoordinate = CLLocationCoordinate2D(
            latitude: route.latitude,
            longitude: route.longitude
        )
        
        let cameraPosition = MapCameraPosition.region(
            MKCoordinateRegion(
                center: routeCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
        )
        
        ScrollView {
            VStack(spacing: 20) {
                
                Image(systemName: "bus.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                    .padding(.top)
                
                Text(route.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 12) {
                    Label("Driver: \(route.driver)", systemImage: "person.fill")
                    
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundStyle(statusColor(route.status))
                        
                        Text("Status: \(route.status)")
                            .foregroundStyle(statusColor(route.status))
                    }
                    
                    Label("Pickup Time: \(route.pickupTime)", systemImage: "clock.fill")
                }
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Route Map")
                        .font(.headline)
                    
                    Map(position: .constant(cameraPosition)) {
                        Marker(route.name, coordinate: routeCoordinate)
                    }
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.bottom)
        }
        .navigationTitle("Route Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
