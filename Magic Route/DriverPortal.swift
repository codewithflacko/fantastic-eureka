//
//  DriverPortal.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/23/26.
//

import SwiftUI

struct DriverPortal: View {
    @StateObject private var simulator = RouteSimulationManager(routes: mockRoutes)
    
    var body: some View {
        DriverHomeView(simulator: simulator, route: simulator.routes.first ?? mockRoutes[0])
            .onAppear {
                simulator.startSimulation()
            }
            .onDisappear {
                simulator.stopSimulation()
            }
    }
}

#Preview {
    DriverPortal()
}
