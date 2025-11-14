//
//  SwiftUIView.swift
//  Moonshot
//
//  Created by Logan Falzarano on 11/13/25.
//

import SwiftUI

struct CrewMember {
    let role: String
    let astronaut: Astronaut
}

struct MissionView: View {
    let mission: Mission
    let crew: [CrewMember]
    
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission

        self.crew = mission.crew.map { member in
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) { width, axis in
                        0.6 * width // 60 % of the parents width
                    }
                
                //add the launch date
                Text(mission.formattedLaunchDate)
                    .font(.headline)
                    .padding(.top)
                
                VStack(alignment: .leading) {
                    MoonShotDivider()
                    
                    Text("Mission Highlights")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                    
                    Text(mission.description)
                    
                    MoonShotDivider()
                    
                    Text("Crew")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                }
                .padding(.horizontal)
            }
            
            CrewView(crew: crew)
            
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    return MissionView(mission: missions.last!, astronauts: astronauts)
        .preferredColorScheme(.dark) //must apply here because our view isn't inside the parent which has the dark color scheme
}
