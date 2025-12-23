import Foundation

class DataService {
    // Note: Using a placeholder URL. Replace with your actual data source.
    let urlString = "https://www.hackingwithswift.com/samples/friendface.json"

    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let users = try decoder.decode([User].self, from: data)
        
        return users
    }
}
