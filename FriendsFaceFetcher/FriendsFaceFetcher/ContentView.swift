//
//  ContentView.swift
//  FriendsFaceFetcher
//
//  Created by Logan Falzarano on 12/23/25.
//

//
//  ContentView.swift
//  FriendsFaceFetcher
//
//  Created by Logan Falzarano on 12/23/25.
//

import SwiftUI

struct ContentView: View {
    @State private var users = [User]()

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
        guard users.isEmpty else { return }

        do {
            let dataService = DataService()
            users = try await dataService.fetchUsers()
        } catch {
            print("Error fetching users: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
