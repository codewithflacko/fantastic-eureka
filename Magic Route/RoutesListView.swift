//
//  RoutesListView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/22/26.
//

import SwiftUI

struct RoutesListView: View {
    let routes: [BusRoute]
    
    var body: some View {
        NavigationStack {
            List(routes) { route in
                NavigationLink(destination: RouteDetailView(route: route)) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(route.name)
                            .font(.headline)
                        
                        Text("Driver: \(route.driver)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Text("Next Stop: \(route.nextStop)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(route.status)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Routes")
        }
    }
}

#Preview {
    RoutesListView(routes: mockRoutes)
}
