import MapKit

class DefaultLocationsRepository: LocationsRepositoryProtocol {
    func getItems() async throws -> [Location] {
        return [Location]()
    }
}

extension Location: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case lat
        case long
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
       
        name = try? container.decode(String.self, forKey: .name)
        
        let lat = try container.decode(Double.self, forKey: .lat)
        let long = try container.decode(Double.self, forKey: .long)
        
        coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}

struct LocationsResponse: Decodable {
    let locations: [Location]
}
