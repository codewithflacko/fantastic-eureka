//
//  DispatchPortal.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/23/26.
//

import SwiftUI

struct DispatchPortalScreen: View {
    @StateObject private var simulator = RouteSimulationManager()

    var body: some View {
        DispatcherView(simulator: simulator)
            .onAppear {
                simulator.startSimulation()
            }
            .onDisappear {
                simulator.stopSimulation()
            }
    }
}
