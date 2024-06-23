import SwiftUI

struct PlacesListView: View {
    enum ViewState {
        case idle
        case loading
        case success(items: [Location])
        case error(error: Error)
    }
    
    @State var viewState: ViewState = .idle
    @State var address: String = ""
    
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
                TextField("Enter your name", text: $address)
                    .submitLabel(.done)
                listView(items: items)
            case .error(let error):
                errorView(error)
            }
        }
        .padding()
        .onSubmit {
            CityCoordinateFinder().getCoordinateFrom(address: address) { coordinate, error in
                guard let coordinate = coordinate, error == nil else { return }
                
                UIApplication.shared.open(URL(string: "wikipedia://places?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)")!)
            }
        }
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
                Link(item.name ?? "", destination: URL(string: "wikipedia://places?lat=\(item.location.coordinate.latitude)&lon=\(item.location.coordinate.longitude)")!)
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
