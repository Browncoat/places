import Foundation
@testable import Places

class MockApiClient: ApiClient {
    var isError: Bool = false
    
    func get(path: String) async throws -> Data {
        if isError {
            throw ApiClientError.networkError
        }
        
        return Response.mock.data(using: .utf8)!
    }
}
