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

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
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
    
    func testViewStateSuccess() throws {
        
    }
    
    func testViewStateLoading() throws {
        
    }
}
