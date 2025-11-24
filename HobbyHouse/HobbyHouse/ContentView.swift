//
//  ContentView.swift
//  HobbyHouse
//
//  Created by Logan Falzarano on 11/23/25.
//

import SwiftUI

// HobbyNotes remains a simple struct (or class)
struct HobbyNotes: Identifiable, Codable {
    var id: UUID = UUID()
    var date: Date
    var note: String
}

@Observable
class Hobby: Identifiable, Codable {
    // No more @Published required! All properties are automatically monitored.
    var id: UUID = UUID()
    var name: String
    var startDate: Date
    var description: String?
    var hobbyNotes: [HobbyNotes] = []
    
    // Initializer remains the same
    init(name: String, description: String? = nil, startDate: Date, hobbyNotes: [HobbyNotes] = []) {
        self.name = name
        self.description = description
        self.startDate = startDate
        self.hobbyNotes = hobbyNotes
    }
    
    // Get notes from the last 7 days
    func getLastSevenDaysActivity() -> [Bool] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var activity: [Bool] = []
        
        for i in (0..<7).reversed() {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let hasNote = hobbyNotes.contains { note in
                    calendar.isDate(note.date, inSameDayAs: date)
                }
                activity.append(hasNote)
            }
        }
        return activity
    }
}

@Observable
final class HobbyStore {
    // Key for UserDefaults
    private let hobbiesKey = "HobbyData"
    
    // The main source of truth for the hobby list
    var hobbies: [Hobby] = []
    
    init() {
        // Load data immediately upon initialization
        loadHobbyData()
    }
    
    // MARK: - Persistence Methods
    
    func saveHobbyData() {
        do {
            // Encode the array of Observable Hobby objects into JSON Data
            let encoder = JSONEncoder()
            let data = try encoder.encode(hobbies)
            
            // Save the Data to UserDefaults
            UserDefaults.standard.set(data, forKey: hobbiesKey)
            print("Hobby data saved successfully.")
        } catch {
            print("Error encoding hobby data: \(error.localizedDescription)")
        }
    }
    
    func loadHobbyData() {
        if let savedData = UserDefaults.standard.data(forKey: hobbiesKey) {
            do {
                // Decode the JSON Data back into an array of Hobby objects
                let decoder = JSONDecoder()
                let decodedHobbyData = try decoder.decode([Hobby].self, from: savedData)
                
                // If successful, update the observable property
                hobbies = decodedHobbyData
                print("Hobby data loaded successfully.")
                
            } catch {
                print("Error decoding hobby data: \(error.localizedDescription)")
                // If decoding fails, use empty data
                hobbies = []
            }
        } else {
            // If no data is found in UserDefaults, use empty data
            hobbies = []
        }
    }
    
    func addNewHobby(_ hobby: Hobby) {
        hobbies.append(hobby)
        // Call save immediately after the mutation
        saveHobbyData()
    }
    
    func deleteHobby(_ hobby: Hobby) {
        hobbies.removeAll { $0.id == hobby.id }
        // Crucial: Save the updated array immediately
        saveHobbyData()
        print("Hobby deleted: \(hobby.name)")
    }
}


struct ContentView: View {
//    @State private var hobbyData: [Hobby] = generateDummyData()
    @Environment(HobbyStore.self) private var hobbyStore
    @State private var showingCreateSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(hobbyStore.hobbies) {hobby in
                        HobbyCardView(hobby: hobby)
                            .padding(.horizontal, 15)

                    }
                }
                .navigationTitle("Hobby House Tracker")
                .toolbar {
                    Button("New Hobby") {
                        showingCreateSheet = true
                    }
                }
            }
            .sheet(isPresented: $showingCreateSheet) {
                CreateHobbyView(onSave: hobbyStore.addNewHobby)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.blue.opacity(0.1)]),
                    startPoint: .bottomLeading, // Bottom-left
                    endPoint: .topTrailing      // Top-right
                )
            ) // Light blue to white gradient
            // ADDED: Save data when the app is about to close (important fallback)
            .onDisappear {
                hobbyStore.saveHobbyData()
            }
        }

        
        
    }
}

#Preview {
    // 1. Create a dummy store instance for the preview
    let previewStore = HobbyStore()
    
    // 2. Inject the store into the preview environment
    return ContentView()
        .environment(previewStore)
    
    // NOTE: You must also update your ContentView to access the store
    // via @Environment(HobbyStore.self) instead of @State private var hobbyStore
    // as per the previous suggested fix.
}
