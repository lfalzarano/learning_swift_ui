// MARK: - EditHobbyView (New View)
import SwiftUI

struct EditHobbyView: View {
    // 1. @Bindable is used here to get two-way access to the HOBBY object.
    @Bindable var hobby: Hobby
    // 2. Used to dismiss the sheet when done.
    @Environment(\.dismiss) var dismiss
    // 3.
    @Environment(HobbyStore.self) private var hobbyStore

    // We use temporary @State variables for the name/description
    // to allow the user to cancel their edits.
    @State private var editedName: String
    @State private var editedDescription: String
    
    // Custom initializer to set the initial state from the hobby object
    init(hobby: Hobby) {
        self.hobby = hobby
        _editedName = State(initialValue: hobby.name)
        _editedDescription = State(initialValue: hobby.description ?? "")
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Details") {
                    TextField("Hobby Name", text: $editedName)
                    
                    TextEditor(text: $editedDescription)
                        .frame(minHeight: 100)
                }
                
                Section {
                    Button("Delete Hobby", role: .destructive) {
                        // FIX: Wrap the mutation and dismissal in withAnimation
                        withAnimation {
                            // 1. Perform the deletion (using the store we accessed from the environment)
                            hobbyStore.deleteHobby(hobby)
                            
                            // 2. Dismiss the sheet (This dismissal will now be animated)
                            dismiss()
                        }
                    }
                    .frame(maxWidth: .infinity) // Center the button
                }
                .listRowBackground(Color.clear) // Optional: Make the background clear for a cleaner look
            }
            .navigationTitle("Edit \(hobby.name)")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Apply changes back to the original @Observable object
                        hobby.name = editedName
                        hobby.description = editedDescription.isEmpty ? nil : editedDescription
                        // CRUCIAL: Trigger the save after the edit
                        hobbyStore.saveHobbyData()
                        dismiss()
                    }
                    .bold()
                }
            }
        }
    }
}
