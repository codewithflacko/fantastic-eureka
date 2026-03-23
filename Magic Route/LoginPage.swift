//
//  LoginPage.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/23/26.
//

import SwiftUI

struct LoginView: View {
    @State private var selectedUser: AppUser?

    var body: some View {
        VStack(spacing: 20) {
            Text("Select User")
                .font(.largeTitle)
                .bold()
                .padding(.top, 40)

            Text("Choose a portal to continue")
                .foregroundColor(.secondary)

            Button {
                selectedUser = parentUser
            } label: {
                Label("Login as Parent", systemImage: "person.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.15))
                    .cornerRadius(12)
            }

            Button {
                selectedUser = dispatcherUser
            } label: {
                Label("Login as Dispatcher", systemImage: "person.3.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange.opacity(0.15))
                    .cornerRadius(12)
            }

            Button {
                selectedUser = driverUser
            } label: {
                Label("Login as Driver", systemImage: "steeringwheel")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.15))
                    .cornerRadius(12)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Login")
        .fullScreenCover(item: $selectedUser) { user in
            MainAppView(user: user)
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}
