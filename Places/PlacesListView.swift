import SwiftUI

struct PlacesListView: View {
    enum ViewState {
        case idle
        case loading
        case success(items: [Location])
        case error(error: Error)
    }
    
    @State var viewState: ViewState = .idle
    
    let repository: any LocationsRepository
    
    init(with repository: any LocationsRepository = DefaultLocationsRepository(with: DefaultApiClient())) {
        self.repository = repository
    }
    
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
                viewState = try await viewState.fetching(from: repository)
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

extension PlacesListView.ViewState {
    func fetching(from repository: LocationsRepository) async throws -> Self {
        do {
            let items = try await repository.getItems()
            return .success(items: items)
        } catch {
            return .error(error: error)
        }
    }
}

#Preview {
    PlacesListView()
}
