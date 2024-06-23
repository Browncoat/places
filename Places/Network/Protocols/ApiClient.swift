import Foundation

protocol ApiClient {
    func get<T>(path: String) -> [T]
}
