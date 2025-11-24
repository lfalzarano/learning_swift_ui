// HobbyHouseApp.swift (UPDATED)

import SwiftUI

@main
struct HobbyHouseApp: App {
    // 1. Create the HobbyStore instance at the application level
    @State private var hobbyStore = HobbyStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // 2. Inject the store into the environment for ALL views
                .environment(hobbyStore)
        }
    }
}
