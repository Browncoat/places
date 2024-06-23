//
//  ContentView.swift
//  Places
//
//  Created by Nate Payne Potter on 21/06/2024.
//

import SwiftUI

struct PlacesListView: View {
    enum ViewState {
        case idle
        case loading
        case success(items: [Location])
        case error(error: Error)
    }
    
    @State var viewState: ViewState = .idle
    
    var body: some View {
        Group {
            switch viewState {
            case .idle:
                idleView
            case .loading:
                loadingView
            case .success(let items):
                listView(items: items)
            case .error(let error):
                errorView(error)
            }
        }
        .padding()
        .task {
            viewState = .loading
            do {
                let items = try await MockLocationsRepository().getItems()
                viewState = .success(items: items)
            } catch {
                viewState = .error(error: error)
            }
        }
    }
}

extension PlacesListView {
    // MARK: SubViews
    
    private var idleView: some View {
        EmptyView()
    }
    
    private var loadingView: some View {
        Text("loading")
    }
    
    private func listView(items: [Location]) -> some View {
        List {
            ForEach(items) { item in
                Text(item.name ?? "unknown")
            }
        }
    }
    
    private func errorView(_ error: Error) -> some View {
        Text(error.localizedDescription.localizedLowercase)
    }
}

#Preview {
    PlacesListView()
}
