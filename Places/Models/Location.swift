import MapKit

struct Location: Identifiable {
    let id = UUID()
    
    let name: String?
    let coordinates: CLLocationCoordinate2D
}
