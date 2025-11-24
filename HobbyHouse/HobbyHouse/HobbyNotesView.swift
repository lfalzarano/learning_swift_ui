//
//  HobbyNotesView.swift
//  HobbyHouse
//
//  Created by Logan Falzarano on 11/23/25.
//

// HobbyNotesView.swift

import SwiftUI

struct NewNoteInputView: View {
    @Bindable var hobby: Hobby
    @Binding var isAddingNewNote: Bool
    @Environment(HobbyStore.self) private var hobbyStore
    
    @State private var newNoteText: String = ""
    @State private var newNoteDate: Date = Date()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Date Picker (Top)
            HStack {
                DatePicker("", selection: $newNoteDate, displayedComponents: .date)
                    .labelsHidden()
                
                Spacer()
                
                // Save Button (Appears when text is present)
                if !newNoteText.isEmpty {
                    Button("Save") {
                        let newNote = HobbyNotes(date: newNoteDate, note: newNoteText)
                        
                        // Add the new note to the hobby's array
                        hobby.hobbyNotes.append(newNote)
                        
                        // CRUCIAL: Trigger the save after adding a note
                        hobbyStore.saveHobbyData()
                        
                        // Reset the state to hide the input card
                        isAddingNewNote = false
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            // Text Input Field (User can type right into it)
            TextEditor(text: $newNoteText)
                .frame(minHeight: 100)
                .scrollContentBackground(.hidden) // Hide the default background to apply custom background
                .background(Color(.systemBackground)) // Use system background for light/dark mode compatibility
                // Apply a rounded border effect
                .overlay(
                    RoundedRectangle(cornerRadius: 10) // Use RoundedRectangle for the outline
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .cornerRadius(10) // Clip the TextEditor content itself to the rounded shape
            
            // Cancel Button
            Button("Cancel") {
                isAddingNewNote = false
            }
            .foregroundColor(.red)
        }
        .padding(.vertical, 8)
    }
}

struct NoteRowView: View {
    let note: HobbyNotes
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(note.date, formatter: NoteRowView.dateFormatter)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(note.note)
                .font(.body)
        }
        .padding(.vertical, 4)
    }
}

struct HobbyNotesView: View {
    // 1. @Bindable is essential! It gives us two-way access to the array of notes
    // inside the existing @Observable Hobby object.
    @Bindable var hobby: Hobby
    
    // 2. State to control the creation of a new, empty note.
    @State private var isAddingNewNote: Bool = false
    @Environment(HobbyStore.self) private var hobbyStore
    
    var body: some View {
        // We use a List for an efficient, natively scrolling experience.
        List {
            // New Note Input (Conditionally visible at the top)
            if isAddingNewNote {
                // The new note input will go here (see section B)
                NewNoteInputView(hobby: hobby, isAddingNewNote: $isAddingNewNote)
                    .listRowSeparator(.hidden) // Hide the separator line
                    .transition(.slide.combined(with: .opacity))
            }
            
            // Existing Notes
            // Sort by date: most recent notes appear at the top.
            ForEach(hobby.hobbyNotes.sorted(by: { $0.date > $1.date })) { note in
                NoteRowView(note: note)
            }
            // Add a swipe-to-delete action
            .onDelete(perform: deleteNote)
        }
        .listStyle(.plain) // Use plain style for a cleaner look
        .navigationTitle("\(hobby.name) Notes")
        .animation(.easeInOut(duration: 0.3), value: isAddingNewNote)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Toggle the state to show the New Note Input at the top
                    isAddingNewNote.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
    }
    
    // Function to handle swipe-to-delete
    func deleteNote(offsets: IndexSet) {
        // Need to find the indices in the original (unsorted) hobbyNotes array
        // This is complex because List shows a sorted array.
        // A simpler approach is to handle deletion within the Hobby model itself
        // or by managing the sorted array's mapping.
        
        // For simplicity right now, we'll use a functional approach:
        let sortedNotes = hobby.hobbyNotes.sorted(by: { $0.date > $1.date })
        
        for index in offsets {
            let noteToDelete = sortedNotes[index]
            hobby.hobbyNotes.removeAll { $0.id == noteToDelete.id }
        }
        
        // CRUCIAL: Trigger the save after deleting a note
        hobbyStore.saveHobbyData()
    }
}
