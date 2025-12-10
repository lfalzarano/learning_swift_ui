//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by Logan Falzarano on 12/9/25.
//

import SwiftData
import SwiftUI

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
