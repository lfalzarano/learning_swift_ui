//
//  AddView.swift
//  iExpense
//
//  Created by Logan Falzarano on 11/6/25.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var type: String = "Personal"
    @State private var amount: Double = 0.0
    
    var expenses: Expenses
    
    let types = ["Personal", "Business"]
    var body: some View {
        
        Form {
            TextField("Name", text: $name)
            Picker("Type", selection: $type) {
                ForEach(types, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            TextField("Amount", value: $amount, format: .currency(code: "USD"))
                .keyboardType(.decimalPad)
        }
        .navigationTitle(Text("Add New Expense"))
        .toolbar {
            
            // 1. CONFIRM Button (Explicitly Trailing)
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Confirm Expense") {
                    let newExpense = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(newExpense)
                    dismiss()
                }
            }
            
            // 2. CANCEL Button (Explicitly Leading)
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        
    
        
    }
}

#Preview {
    AddView(expenses: Expenses())
}
