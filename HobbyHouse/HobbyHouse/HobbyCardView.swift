// HobbyCard.swift (Updated)

import SwiftUI

struct HobbyCardView: View {
    // FIX: Still needs @Bindable to allow the sheet to pass a Binding to it
    @Bindable var hobby: Hobby
    
    // State variable to control the visibility of the modal sheet
    @State private var showingEditSheet = false
    
    // Make dateFormatter static for correctness and efficiency (as discussed earlier)
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private var lastSevenDaysActivity: [Bool] {
        hobby.getLastSevenDaysActivity()
    }
    
    // Removed unused 'numberOfDays' property
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Title (display only)
                Text(hobby.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Add the Edit Button (Presents the Sheet)
                Button {
                    showingEditSheet = true
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                // Attach the sheet modifier to the edit button or the main container.
                // Using a sheet allows for a focused editing flow.
                .sheet(isPresented: $showingEditSheet) {
                    // Pass the original hobby object to the sheet view
                    EditHobbyView(hobby: hobby)
                }
            }
            
            // Description (display only)
            if let description = hobby.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            HStack(spacing: 0) {
                // Start Date
                // FIX: Access static formatter via Type Name
                Text("Started: \(hobby.startDate, formatter: HobbyCardView.dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(.top, 4)
            }
            
            // 7-Day Activity Tracker
            HStack(spacing: 0) {
                // Activity dots
                HStack(spacing: 6) {
                    ForEach(0..<7, id: \.self) { index in
                        Circle()
                            .fill(index < lastSevenDaysActivity.count && lastSevenDaysActivity[index] ? Color.green : Color.gray.opacity(0.3))
                            .frame(width: 24, height: 24)
                    }
                }
                
                Spacer()
                
                // Track Notes Button
                Button(action: {
                    // do nothing for now
                }) {
                    NavigationLink(destination: HobbyNotesView(hobby: hobby)) {
                        Text("Track Notes")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 220)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}


#Preview {
    // Assuming generateDummyData() is accessible here
    HobbyCardView(hobby: generateDummyData()[0])
}
