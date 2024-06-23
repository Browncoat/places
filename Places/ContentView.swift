//
//  ContentView.swift
//  Places
//
//  Created by Nate Payne Potter on 21/06/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            let items = try? await MockLocationsRepository().getItems()
            print(items)
        }
    }
}

#Preview {
    ContentView()
}
