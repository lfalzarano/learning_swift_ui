//
//  UserDetailView.swift
//  FriendsFaceFetcher
//
//  Created by Logan Falzarano on 12/23/25.
//

import SwiftUI

struct UserDetailView: View {
    let user: User

    var body: some View {
        List {
            Section(header: Text("Details")) {
                Text("Age: \(user.age)")
                Text("Company: \(user.company)")
                Text("Email: \(user.email)")
            }

            Section(header: Text("Friends")) {
                ForEach(user.friends) { friend in
                    Text(friend.name)
                }
            }
        }
        .navigationTitle(user.name)
    }
}
