//
//  ContentView.swift
//  iExpense
//
//  Created by Logan Falzarano on 11/5/25.
//

import SwiftUI
import SwiftData

@Model
class ExpenseItem {

    var name: String
    var type: String
    var amount: Double
    
    var expenseColor: Color {
        if amount < 10.0 {
            Color.green
        } else if amount < 100.0 {
            Color.orange
        } else {
            Color.red
        }
    }
    
    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }
}


//@Model
//class Expenses {
//    var items: [ExpenseItem] = [ExpenseItem]()
//    
//    init() {}
//}

enum SortOption: String, CaseIterable, Identifiable {
    case name = "Name"
    case amount = "Amount"
    
    var id: String { rawValue }
    
    // This is the "Magic" property that converts the choice into descriptors
    var descriptors: [SortDescriptor<ExpenseItem>] {
        switch self {
        case .name:
            return [SortDescriptor(\ExpenseItem.name), SortDescriptor(\ExpenseItem.amount)]
        case .amount:
            return [SortDescriptor(\ExpenseItem.amount, order: .reverse), SortDescriptor(\ExpenseItem.name)]
        }
    }
}

enum FilterOption: String, CaseIterable, Identifiable {
    case all = "All"
    case personal = "Personal"
    case business = "Business"
    
    var id: String { rawValue }
}

struct ContentView: View {
    //@State keeps the object alive
    //@Observable checks if the data has changed
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [ExpenseItem]
//    @State private var showingAddExpenseView: Bool = false
    
    @State private var filterType: FilterOption = .all
    @State private var sortOption: SortOption = .name
    
    var body: some View {
        NavigationStack {
            ExpensesList(sortOrder: sortOption.descriptors, filter: filterType)
                .navigationTitle(Text("iExpenses"))
                .toolbar {
        //                Button("Add Expense", systemImage: "plus") {
        //                    showingAddExpenseView.toggle()
        //                }
                    NavigationLink(destination: AddView()) {
                        Text("Add Expense")
                    }
                    
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOption) {
                            Text("Sort by Name").tag(SortOption.name)
                            Text("Sort by Amount").tag(SortOption.amount)
                        }
                    }
                    
                    // 2. Filter Menu (Adding this so you can actually use your enum!)
                    Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
                        Picker("Filter", selection: $filterType) {
                            ForEach(FilterOption.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    }
                }
        }
        
//        .sheet(isPresented: $showingAddExpenseView, content: {
//            AddView(expenses: expenses)
//        })
    }
    
//    func removeItems(at offsets: IndexSet, from filteredItems: [ExpenseItem]) {
//        for offset in offsets {
//            if let index = expenses.firstIndex(where: { $0.id == filteredItems[offset].id }) {
//                expenses.remove(at: index)
//            }
//        }
//    }
    
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

//#Preview {
//    ContentView()
//}
