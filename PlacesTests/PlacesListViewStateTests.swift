import XCTest
@testable import Places

final class PlacesListViewStateTests: XCTestCase {
    var mockApiClient: MockApiClient!
    var repository: LocationsRepository!
    var placesListView: PlacesListView!

    override func setUpWithError() throws {
        mockApiClient = MockApiClient()
        repository = DefaultLocationsRepository(with: mockApiClient)
        placesListView = PlacesListView(with: repository)
    }

    func testViewStateError() async throws {
        // GIVEN
        mockApiClient.isError = true
        
        // WHEN
        let viewState = try await placesListView.viewState.fetching(from: repository)
        
        // THEN
        guard case PlacesListView.ViewState.error(let error) = viewState, case ApiClientError.networkError = error else {
            XCTFail("Incorrect ViewState \(viewState)")
            return
        }
    }
    
    func testViewStateSuccess() async throws {
        // GIVEN
        mockApiClient.isError = false
        
        // WHEN
        let viewState = try await placesListView.viewState.fetching(from: repository)
        
        // THEN
        guard case PlacesListView.ViewState.error(let error) = viewState, case ApiClientError.networkError = error else {
            XCTFail("Incorrect ViewState \(viewState)")
            return
        }
    }
    
    func testViewStateLoading() async throws {
        // GIVEN
        mockApiClient.isError = true
        
        // WHEN
        let viewState = try await placesListView.viewState.fetching(from: repository)
        
        // THEN
        guard case PlacesListView.ViewState.error(let error) = viewState, case ApiClientError.networkError = error else {
            XCTFail("Incorrect ViewState \(viewState)")
            return
        }
    }
}
