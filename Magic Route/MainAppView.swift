//
//  MainAppView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/23/26.
//

import SwiftUI

struct MainAppView: View {
    let user: AppUser
    @Environment(\.dismiss) private var dismiss
    @StateObject private var routeManager = RouteSimulationManager(route: sampleRoute)

    var body: some View {
        NavigationStack {
            Group {
                switch user.role {
                case .parent:
                    ParentHomeView(user: user, onLogout: {
                        dismiss()
                    })
                case .dispatcher:
                    DispatcherHomeView(user: user, onLogout: {
                        dismiss()
                    })
                case .driver:
                    DriverHomeView(user: user, onLogout: {
                        dismiss()
                
                    })
                }
            }
            .environmentObject(routeManager)
        }
    }
}
