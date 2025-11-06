//
//  ContentView.swift
//  iExpense
//
//  Created by Logan Falzarano on 11/5/25.
//

import SwiftUI
import Observation

struct ExpenseItem {
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items: [ExpenseItem] = []
}

struct ContentView: View {
    //@State keeps the object alive
    //@Observable checks if the data has changed
    @State private var expenses: Expenses = Expenses()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items, id: \.name) { item in
                    Text(item.name)
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle(Text("iExpenses"))
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    let expense = ExpenseItem(name: "Test", type: "Test", amount: 100)
                    expenses.items.append(expense)
                }
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
