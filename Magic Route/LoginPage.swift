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
            VStack(spacing: 20) {
                Text("Magic Route")
                    .font(.largeTitle.bold())

                Text("Choose a portal")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                NavigationLink {
                    ParentHomeViewScreen()
                } label: {
                    portalCard(
                        title: "Parent Portal",
                        subtitle: "Track route progress and arrival updates",
                        systemImage: "person.2.fill"
                    )
                }

                NavigationLink {
                    DispatchPortalScreen()
                } label: {
                    portalCard(
                        title: "Dispatcher Portal",
                        subtitle: "Monitor all routes and delays",
                        systemImage: "dot.radiowaves.left.and.right"
                    )
                }

                NavigationLink {
                    DriverPortalScreen()
                } label: {
                    portalCard(
                        title: "Driver Portal",
                        subtitle: "Manage route flow and report issues",
                        systemImage: "steeringwheel"
                    )
                }
            }
            .padding()
        }
    }

    private func portalCard(title: String, subtitle: String, systemImage: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.title2)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

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
