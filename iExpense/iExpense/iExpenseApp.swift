//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Logan Falzarano on 11/5/25.
//

import SwiftData
import SwiftUI

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
