protocol LocationsRepository {
    func getItems() async throws -> [Location]
}
