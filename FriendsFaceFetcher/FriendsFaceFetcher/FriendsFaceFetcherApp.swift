//
//  FriendsFaceFetcherApp.swift
//  FriendsFaceFetcher
//
//  Created by Logan Falzarano on 12/23/25.
//

import SwiftUI
import SwiftData

@main
struct FriendsFaceFetcherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
