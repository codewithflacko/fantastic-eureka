//
//  RouteDetailView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/20/26.
//
import SwiftUI

struct RouteDetailView: View {
    let route: BusRoute
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(route.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Driver: \(route.driver)")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Status")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(route.status)
                                .foregroundColor(.blue)
                        }
                        
                        HStack {
                            Text("Next Stop")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(route.nextStop)
                        }
                        
                        HStack {
                            Text("ETA")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(route.eta)
                        }
                        
                        HStack {
                            Text("Students")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(route.studentsOnBus)/\(route.capacity)")
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Stops")
                            .font(.headline)
                        
                        ForEach(route.stops) { stop in
                            HStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.7))
                                    .frame(width: 10, height: 10)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(stop.name)
                                        .fontWeight(.medium)
                                    Text(stop.time)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
                }
                .padding()
            }
            .navigationTitle("Route Details")
        }
    }
}

#Preview {
    RouteDetailView(route: mockRoutes.first!)
}
