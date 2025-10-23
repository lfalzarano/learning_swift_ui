//
//  ContentView.swift
//  RPSBrainTrainer
//
//  Created by Logan Falzarano on 10/22/25.
//

import SwiftUI

enum UserGoal {
    case win, lose
}

enum RPSMove: String, CaseIterable, Identifiable {
    case rock, scissors, paper
    
    var id: String { rawValue }
    
    var emoji: String {
            switch self {
            case .rock: return "🪨"
            case .scissors: return "✂️"
            case .paper: return "📄"
            }
        }
        
        // Game logic built into the enum
        func beats(_ other: RPSMove) -> Bool {
            switch (self, other) {
            case (.rock, .scissors), (.scissors, .paper), (.paper, .rock):
                return true
            default:
                return false
            }
        }
}

struct ContentView: View {
    @State private var botMove: RPSMove = .rock
    @State private var userGoal: UserGoal = .win
    @State private var userScore: Int = 0
    
    var body: some View {
        VStack {
            userGoal == .win ? Text("What wins against \(botMove.emoji)?") : Text("What loses to \(botMove.emoji)?")
            
            HStack {
                ForEach(RPSMove.allCases, id: \.id) { move in
                    Button(move.emoji) {
                        evaluateRound(userMove: move)
                    }
                }
            }
            
            Text("Your score: \(userScore)")
            
        }
    }
    
    func evaluateRound(userMove: RPSMove) {
        let userWon = userMove.beats(botMove)
        if userWon && userGoal == .win || !userWon && userGoal == .lose {
            userScore += 1
        }
        botMove = .allCases.randomElement()!
        //randomize user goal
        userGoal = Bool.random() ? .win : .lose
    }
}

#Preview {
    ContentView()
}
