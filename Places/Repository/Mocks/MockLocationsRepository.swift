import Foundation

class MockLocationsRepository: LocationsRepository {
    func getItems() async throws -> [Location] {
        let data = Response.mock.data(using: .utf8)!
        
        let locations = try JSONDecoder().decode(LocationsResponse.self, from: data).locations
        
        return locations
    }
}
