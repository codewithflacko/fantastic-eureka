//
//  DriverPortal.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/23/26.
//
import SwiftUI

struct DriverPortalScreen: View {
    @StateObject private var simulator = RouteSimulationManager()

    let currentDriver = "Ms. Johnson"

    var body: some View {
        DriverHomeView(
            simulator: simulator,
            driverName: currentDriver
        )
        .onAppear {
            simulator.startSimulation()
        }
        .onDisappear {
            simulator.stopSimulation()
        }
    }
}
