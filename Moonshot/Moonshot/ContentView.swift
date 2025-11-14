//
//  ContentView.swift
//  Moonshot
//
//  Created by Logan Falzarano on 11/9/25.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    @State private var showingGrid = true
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 10)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if showingGrid {
                    gridView
                } else {
                    listView
                }
            }
            .navigationTitle(Text("Moonshot"))
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .toolbar {
                Button {
                    showingGrid.toggle()
                } label: {
                    Image(systemName: showingGrid ? "list.bullet" : "square.grid.2x2")
                        .foregroundStyle(.white)
                }
            }
        }
    }
    
    var gridView: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(missions) { mission in
                NavigationLink {
                    MissionView(mission: mission, astronauts: astronauts)
                } label: {
                    VStack {
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding()
                        VStack {
                            Text(mission.displayName)
                                .font(.headline)
                                .foregroundStyle(.white)
                            Text(mission.formattedLaunchDate)
                                .font(.caption)
                                .foregroundStyle(.gray.opacity(0.75))
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(.lightBackground)
                    }
                    .clipShape(.rect(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.lightBackground)
                    )
                }
            }
        }
        .padding([.horizontal, .bottom], 10)
    }
    
    var listView: some View {
        LazyVStack(spacing: 10) {
            ForEach(missions) { mission in
                NavigationLink {
                    MissionView(mission: mission, astronauts: astronauts)
                } label: {
                    HStack {
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding()
                        
                        VStack(alignment: .leading) {
                            Text(mission.displayName)
                                .font(.headline)
                                .foregroundStyle(.white)
                            Text(mission.formattedLaunchDate)
                                .font(.caption)
                                .foregroundStyle(.gray.opacity(0.75))
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .background(.lightBackground)
                    .clipShape(.rect(cornerRadius: 10))
                }
            }
        }
        .padding([.horizontal, .bottom], 10)
    }
}

#Preview {
    ContentView()
}
