//
//  MainAppView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/23/26.
//

import SwiftUI

struct MainAppView: View {
    @StateObject private var simulator = RouteSimulationManager(routes: mockRoutes)
    
    var body: some View {
        TabView {
            ParentHomeView(simulator: simulator)
                .tabItem {
                    Label("Parent", systemImage: "person.fill")
                }
            
            DispatcherView(simulator: simulator)
                .tabItem {
                    Label("Dispatch", systemImage: "bus.doubledecker.fill")
                }
        }
        .onAppear {
            simulator.startSimulation()
        }
        .onDisappear {
            simulator.stopSimulation()
        }
    }
}

#Preview {
    MainAppView()
}
