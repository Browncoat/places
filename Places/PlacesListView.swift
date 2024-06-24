import SwiftUI

struct PlacesListView: View {
    enum ViewState {
        case loading
        case success(items: [Location])
        case error(error: Error)
    }
    
    @State var viewState: ViewState = .loading
    @State var address: String = ""
    @State var isErrorPresented: Bool = false
    
    let repository: any LocationsRepository
    
    init(with repository: any LocationsRepository = DefaultLocationsRepository(with: DefaultApiClient())) {
        self.repository = repository
    }
    
    var body: some View {
        Group {
            switch viewState {
            case .loading:
                loadingView
            case .success(let items):
                TextField("Type a place or address.", text: $address)
                    .submitLabel(.done)
                    .accessibilityLabel(Text("Type a place address"))
                    .accessibilityAddTraits([.isSearchField])
                listView(items: items)
            case .error(let error):
                errorView(error)
            }
        }
        .padding()
        .onSubmit {
            CityCoordinateFinder().getCoordinateFrom(address: address) { coordinate, error in
                guard let coordinate = coordinate, error == nil else { return }
                
                guard UIApplication.shared.canOpenURL(URL(string: "wikipedia://places")!) else {
                    isErrorPresented = true
                    return
                }
                
                UIApplication.shared.open(URL(string: "wikipedia://places?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)")!)
            }
        }
        .alert(isPresented: .constant(isErrorPresented)) {
            Alert(
                title: Text("Ooops"),
                message: Text("Wikipedia App is not installed."),
                dismissButton: .default(Text("OK")) { }
            )
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
    
    private var loadingView: some View {
        ProgressView()
            .scaleEffect(.init(width: 2, height: 2))
    }
    
    private func listView(items: [Location]) -> some View {
        List {
            ForEach(items) { item in
                Link(item.name ?? "", destination: URL(string: "wikipedia://places?lat=\(item.location.coordinate.latitude)&lon=\(item.location.coordinate.longitude)")!)
                    .accessibilityLabel(Text(item.name ?? "no name"))
                    .accessibilityAddTraits([.isButton])
                    .accessibilityHint(Text("Opens location on map in Wikipedia app (if installed)"))
            }
        }
        .accessibilityLabel(Text("Place names list"))
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
