//
//  CreateHobbyView.swift
//  HobbyHouse
//
//  Created by Logan Falzarano on 11/23/25.
//

// CreateHobbyView.swift

import SwiftUI

struct CreateHobbyView: View {
    // This closure passes the completed Hobby object back to the parent view (ContentView)
    var onSave: (Hobby) -> Void
    @Environment(\.dismiss) var dismiss

    // Local state for collecting user input
    @State private var newName: String = ""
    @State private var newDescription: String = ""
    @State private var newStartDate: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Dueling, for example") {
                    TextField("Fencing, for example", text: $newName)
                    
                    // Use a ZStack to layer the placeholder and the TextEditor
                    ZStack(alignment: .topLeading) {
                        if newDescription.isEmpty {
                            // Placeholder Text
                            Text("Improving on my sword wielding abilities 🤺")
                                .foregroundColor(Color(uiColor: .placeholderText))
                                .padding(.top, 8)
                                .padding(.horizontal, 5)
                        }

                        // The actual TextEditor, bound to the state variable
                        TextEditor(text: $newDescription)
                            .frame(minHeight: 100)
                            // Ensure the font matches the placeholder
                            .font(.body)
                            .scrollContentBackground(.hidden) //make the background invisible allowing the placeholder text to show through
                    }
                    .frame(minHeight: 100) // Apply the frame to the ZStack
                    
                    DatePicker("Start Date", selection: $newStartDate, displayedComponents: .date)
                }
            }
            .navigationTitle("New Hobby")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // 1. Construct the new Hobby object
                        let newHobby = Hobby(
                            name: newName,
                            description: newDescription.isEmpty ? nil : newDescription,
                            startDate: newStartDate
                        )
                        // 2. Pass it back to ContentView
                        onSave(newHobby)
                        dismiss()
                    }
                    .disabled(newName.isEmpty)
                    .bold()
                }
            }
        }
    }
}
