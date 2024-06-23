protocol LocationsRepositoryProtocol {
    func getItems() async throws -> [Location]
}
