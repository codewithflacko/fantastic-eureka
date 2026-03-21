//
//  RouteDetailView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/20/26.
//

import SwiftUI
import MapKit

struct RouteDetailView: View {
    @Binding var route: BusRoute
    
    @State private var cameraPosition: MapCameraPosition
    
    init(route: Binding<BusRoute>) {
        self._route = route
        _cameraPosition = State(
            initialValue: .region(
                MKCoordinateRegion(
                    center: route.wrappedValue.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            )
        )
    }
    
    var progressValue: Double {
        let completedStops = route.stops.filter { $0.isCompleted }.count
        let totalStops = route.stops.count
        
        guard totalStops > 0 else { return 0 }
        return Double(completedStops) / Double(totalStops)
    }
    
    func advanceToNextStop() {
        guard let currentIndex = route.stops.firstIndex(where: { $0.isCurrent }) else { return }
        
        route.stops[currentIndex].isCurrent = false
        route.stops[currentIndex].isCompleted = true
        route.stops[currentIndex].eta = "Completed"
        route.studentsOnBus += route.stops[currentIndex].studentsWaiting
        route.stops[currentIndex].studentsWaiting = 0
        
        let nextIndex = currentIndex + 1
        
        if nextIndex < route.stops.count {
            route.stops[nextIndex].isCurrent = true
            route.nextStop = route.stops[nextIndex].name
            route.status = "In Route"
        } else {
            route.nextStop = "Route Complete"
            route.status = "On Time"
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(route.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Driver: \(route.driver)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "bus.fill")
                            .font(.system(size: 34))
                            .foregroundColor(.blue)
                    }
                    
                    Divider()
                    
                    HStack {
                        DetailStatCard(
                            title: "Students",
                            value: "\(route.studentsOnBus)",
                            icon: "person.3.fill"
                        )
                        
                        DetailStatCard(
                            title: "Status",
                            value: route.status,
                            icon: "clock.fill"
                        )
                    }
                    
                    DetailWideCard(
                        title: "Next Stop",
                        value: route.nextStop,
                        icon: "mappin.and.ellipse"
                    )
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 4)
                .padding(.horizontal)
                .padding(.top)
                
                VStack(alignment: .leading, spacing: 14) {
                    Text("Route Progress")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    ProgressView(value: progressValue)
                        .progressViewStyle(.linear)
                    
                    Text("\(Int(progressValue * 100))% complete")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 4)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 14) {
                    Text("Update Bus Status")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 10) {
                        StatusButton(title: "On Time", color: .green, selected: route.status == "On Time") {
                            route.status = "On Time"
                        }
                        
                        StatusButton(title: "In Route", color: .orange, selected: route.status == "In Route") {
                            route.status = "In Route"
                        }
                        
                        StatusButton(title: "Delayed", color: .red, selected: route.status == "Delayed") {
                            route.status = "Delayed"
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 4)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 14) {
                    Text("Route Controls")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Button(action: advanceToNextStop) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                            Text("Advance to Next Stop")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 4)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 14) {
                    Text("Stop Progress")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    ForEach(route.stops) { stop in
                        StopRowView(stop: stop)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 4)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Route Map")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Map(position: $cameraPosition) {
                        Annotation(route.name, coordinate: route.coordinate) {
                            VStack(spacing: 4) {
                                Image(systemName: "bus.fill")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                                
                                Text(route.name)
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 3)
                                    .background(Color.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 4)
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .padding(.vertical)
        }
        .background(Color.blue.opacity(0.06))
        .navigationTitle("Route Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatusButton: View {
    let title: String
    let color: Color
    let selected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(selected ? color.opacity(0.2) : Color.gray.opacity(0.1))
                .foregroundColor(selected ? color : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct StopRowView: View {
    let stop: BusStop
    
    var iconName: String {
        if stop.isCompleted {
            return "checkmark.circle.fill"
        } else if stop.isCurrent {
            return "location.circle.fill"
        } else {
            return "circle"
        }
    }
    
    var iconColor: Color {
        if stop.isCompleted {
            return .green
        } else if stop.isCurrent {
            return .blue
        } else {
            return .gray
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: iconName)
                .foregroundColor(iconColor)
                .font(.title3)
                .padding(.top, 2)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(stop.name)
                    .font(.headline)
                
                HStack {
                    Text("ETA: \(stop.eta)")
                    Spacer()
                    Text("\(stop.studentsWaiting) waiting")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.08))
        .cornerRadius(14)
    }
}

struct DetailStatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.blue.opacity(0.08))
        .cornerRadius(16)
    }
}

struct DetailWideCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.orange.opacity(0.10))
        .cornerRadius(16)
    }
}

#Preview {
    NavigationStack {
        RouteDetailPreviewWrapper()
    }
}

struct RouteDetailPreviewWrapper: View {
    @State private var sampleRoute = BusRoute(
        name: "Route A",
        driver: "Mike",
        status: "In Route",
        studentsOnBus: 18,
        nextStop: "Palm Ave & 3rd St",
        stops: [
            BusStop(name: "School Pickup Zone", eta: "Completed", studentsWaiting: 0, isCompleted: true, isCurrent: false),
            BusStop(name: "Ocean View Dr", eta: "Completed", studentsWaiting: 0, isCompleted: true, isCurrent: false),
            BusStop(name: "Palm Ave & 3rd St", eta: "2 min", studentsWaiting: 3, isCompleted: false, isCurrent: true),
            BusStop(name: "7th Ave Station", eta: "6 min", studentsWaiting: 4, isCompleted: false, isCurrent: false)
        ],
        coordinate: CLLocationCoordinate2D(latitude: 32.6781, longitude: -117.1720)
    )
    
    var body: some View {
        RouteDetailView(route: $sampleRoute)
    }
}
