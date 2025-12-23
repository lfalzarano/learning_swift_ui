//
//  ExpensesList.swift
//  iExpense
//
//  Created by Logan Falzarano on 12/21/25.
//

import SwiftData
import SwiftUI

struct ExpensesList: View {
    @Query var items: [ExpenseItem] = [] //must be query to get the property wrapper _items
    @Environment(\.modelContext) var modelContext
    
    var personalExpenses: [ExpenseItem] {
        items.filter { $0.type == "Personal" }
    }
    var businessExpenses: [ExpenseItem] {
        items.filter { $0.type == "Business" }
    }
    
    // No @Binding needed! Just a regular initializer.
    init(sortOrder: [SortDescriptor<ExpenseItem>], filter: FilterOption) {
        // We pull the rawValue out to use inside the Predicate
        let filterString = filter.rawValue
        
        _items = Query(filter: #Predicate<ExpenseItem> { item in
            if filterString == "All" {
                return true
            } else {
                return item.type == filterString
            }
        }, sort: sortOrder)
    }
    
    func removeItems(at offsets: IndexSet, from filteredItems: [ExpenseItem]) {
        for offset in offsets {
            // 1. Find the specific object in the list being displayed
            let item = filteredItems[offset]
            
            // 2. Tell the database to delete it directly
            modelContext.delete(item)
        }
    }
    
    var body: some View {
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
    }
    
}

//#Preview {
//    ExpensesList()
//}
