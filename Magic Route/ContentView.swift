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
                Color.blue.opacity(0.1)
                    .ignoresSafeArea()

                VStack(spacing: 25) {
                    Image(systemName: "bus.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)

                    Text("Welcome to Magic Route")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Text("Track your school bus routes in real time")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    NavigationLink(destination: RoutesView()) {
                        Text("View Routes")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 30)
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
