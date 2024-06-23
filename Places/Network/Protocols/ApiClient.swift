import Foundation

enum ApiClientError: Error {
    case malformedURL
    case networkError
}

protocol ApiClient {
    func get(path: String) async throws -> Data
}
