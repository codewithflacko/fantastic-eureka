//
//  MainAppView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/23/26.
//

import SwiftUI

struct MainAppView: View {
    var body: some View {
        TabView {
            ParentHomeViewScreen()
                .tabItem {
                    Label("Parent", systemImage: "person.2.fill")
                }

            DispatchPortalScreen()
                .tabItem {
                    Label("Dispatch", systemImage: "dot.radiowaves.left.and.right")
                }

            DriverPortalScreen()
                .tabItem {
                    Label("Driver", systemImage: "steeringwheel")
                }
        }
    }
}
