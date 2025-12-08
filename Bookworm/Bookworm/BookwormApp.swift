//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Logan Falzarano on 12/4/25.
//

import SwiftData
import SwiftUI

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
