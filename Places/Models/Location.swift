import CoreLocation

struct Location: Identifiable {
    let id = UUID()
    
    let name: String?
    let location: CLLocation
}
