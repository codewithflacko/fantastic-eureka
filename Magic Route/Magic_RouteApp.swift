//
//  Magic_RouteApp.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/18/26.
//

import SwiftUI

@main
struct MagicRouteApp: App {
    @StateObject private var routeManager = RouteSimulationManager(route: sampleRoute)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(routeManager)
        }
    }
}
