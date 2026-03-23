//
//  ContentView.swift
//  Magic Route
//
//  Created by Flacko Farquharson on 3/18/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.blue.opacity(0.2), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer()

                    Image(systemName: "bus.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)

                    Text("Magic Route")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Helping schools, parents, and districts track bus routes in real time.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)

                    NavigationLink(destination: RoutesListView()) {
                        Text("View Bus Routes")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(16)
                            .padding(.horizontal, 30)
                    }

                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
