//
//  ContentView.swift
//  iExpense
//
//  Created by Logan Falzarano on 11/5/25.
//

import SwiftUI
import Observation

struct ExpenseItem: Identifiable, Codable {
    var id: UUID = UUID() //gets create automatically in the initializer
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items: [ExpenseItem] = [] {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "items") {
            //decoder an array of ExpenseItems because this type conforms to Codable
            //.self refers to the type
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
            }
        }
        items = []
    }
}

struct ContentView: View {
    //@State keeps the object alive
    //@Observable checks if the data has changed
    @State private var expenses: Expenses = Expenses()
    @State private var showingAddExpenseView: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text("\(item.type)")
                                .font(.subheadline)
                        }
                        Spacer()
                        Text(item.amount, format: .currency(code: "USD"))
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle(Text("iExpenses"))
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpenseView.toggle()
                }
            }
        }
        .sheet(isPresented: $showingAddExpenseView, content: {
            AddView(expenses: expenses)
        })
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
