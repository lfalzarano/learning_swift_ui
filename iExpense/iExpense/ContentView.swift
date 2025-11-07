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
    
    var expenseColor: Color {
        if amount < 10.0 {
            Color.green
        } else if amount < 100.0 {
            Color.orange
        } else {
            Color.red
        }
    }
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
        } else {
            items = []
        }
    }
}

struct ContentView: View {
    //@State keeps the object alive
    //@Observable checks if the data has changed
    @State private var expenses: Expenses = Expenses()
    @State private var showingAddExpenseView: Bool = false
    var personalExpenses: [ExpenseItem] {
        expenses.items.filter { $0.type == "Personal" }
    }
    var businessExpenses: [ExpenseItem] {
        expenses.items.filter { $0.type == "Business" }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal Expenses") {
                    ForEach(personalExpenses) { item in
                        ExpenseRow(item: item)
                    }
                    .onDelete { offsets in
                        removeItems(at: offsets, from: personalExpenses)
                    }
                }
                
                Section("Business Expenses") {
                    ForEach(businessExpenses) { item in
                        ExpenseRow(item: item)
                    }
                    .onDelete { offsets in
                        removeItems(at: offsets, from: businessExpenses)
                    }
                }
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
    
    func removeItems(at offsets: IndexSet, from filteredItems: [ExpenseItem]) {
        for offset in offsets {
            if let index = expenses.items.firstIndex(where: { $0.id == filteredItems[offset].id }) {
                expenses.items.remove(at: index)
            }
        }
    }
}

struct ExpenseRow : View {
    var item: ExpenseItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text("\(item.type)")
                    .font(.subheadline)
            }
            Spacer()
            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .foregroundStyle(item.expenseColor)
        }
    }
}

#Preview {
    ContentView()
}
