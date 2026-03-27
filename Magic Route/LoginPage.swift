//
//  LoginPage.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/23/26.
//

import SwiftUI

struct LoginPage: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                Image(systemName: "bus.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.blue)
                
                Text("Magic Route")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Choose your portal")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 16) {
                    NavigationLink(destination: ParentPortalScreen()) {
                        portalCard(
                            title: "Parent",
                            subtitle: "Track route progress and bus arrival",
                            icon: "person.fill"
                        )
                    }
                    
                    NavigationLink(destination: DispatchPortal()) {
                        portalCard(
                            title: "Dispatch",
                            subtitle: "Monitor active routes and route status",
                            icon: "bus.doubledecker.fill"
                        )
                    }
                    
                    NavigationLink(destination: DriverPortal()) {
                        portalCard(
                            title: "Driver",
                            subtitle: "View route details and assigned stops",
                            icon: "steeringwheel"
                        )
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func portalCard(title: String, subtitle: String, icon: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 44, height: 44)
                .background(Color.blue.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

struct ParentPortalScreen: View {
    @StateObject private var simulator = RouteSimulationManager(routes: mockRoutes)
    
    var body: some View {
        ParentHomeView(simulator: simulator)
            .onAppear {
                simulator.startSimulation()
            }
            .onDisappear {
                simulator.stopSimulation()
            }
    }
}

#Preview {
    LoginPage()
}
