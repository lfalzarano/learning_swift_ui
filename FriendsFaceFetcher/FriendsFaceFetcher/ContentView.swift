//
//  ContentView.swift
//  FriendsFaceFetcher
//
//  Created by Logan Falzarano on 12/23/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \User.name) var users: [User]

    var body: some View {
        NavigationStack {
            List(users) { user in
                NavigationLink(destination: UserDetailView(user: user)) {
                    HStack {
                        Text(user.name)
                        Spacer()
                        Image(systemName: "circle.fill")
                            .foregroundColor(user.isActive ? .green : .red)
                    }
                }
            }
            .navigationTitle("Friends")
            .task {
                await fetchData()
            }
        }
    }

    func fetchData() async {
        if users.isEmpty {
            do {
                let dataService = DataService()
                let downloadedUsers = try await dataService.fetchUsers()
                
                for user in downloadedUsers {
                    modelContext.insert(user)
                }
                
            } catch {
                print("Error fetching or saving users: \(error)")
            }
        }
    }
}

#Preview {
    do {
        let container = try ModelContainer(for: User.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        return ContentView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
