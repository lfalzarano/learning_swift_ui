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
    @State private var animateEmoji = false
    @State private var roundsPlayed: Int = 0
    @State private var showFinalScoreAlert: Bool = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Score display
                VStack(spacing: 8) {
                    Text("Score")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("\(userScore)")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                
                // Bot's move
                VStack(spacing: 15) {
                    Text("Computer plays:")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text(botMove.emoji)
                        .font(.system(size: 120))
                        .scaleEffect(animateEmoji ? 1.0 : 0.8)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: animateEmoji)
                }
                
                // Goal instruction
                Text(userGoal == .win ? "Find a winning move!" : "Find a losing move!")
                    .font(.title2.bold())
                    .foregroundColor(userGoal == .win ? .green : .red)
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(userGoal == .win ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    )
                
                Spacer()
                
                // User's move buttons
                HStack(spacing: 20) {
                    ForEach(RPSMove.allCases, id: \.id) { move in
                        Button {
                            evaluateRound(userMove: move)
                        } label: {
                            Text(move.emoji)
                                .font(.system(size: 70))
                                .frame(width: 100, height: 100)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .alert("Game Over!", isPresented: $showFinalScoreAlert) {
            Button("Play Again") {
                resetGame()
            }
        } message: {
            Text("Your score is \(userScore) out of \(roundsPlayed)")
        }
    }
    
    func evaluateRound(userMove: RPSMove) {
        let userWon = userMove.beats(botMove)
        if userWon && userGoal == .win || !userWon && userGoal == .lose {
            userScore += 1
        } else {
            userScore = max(0, userScore - 1)
        }
        botMove = .allCases.randomElement()!
        userGoal = Bool.random() ? .win : .lose
        roundsPlayed += 1
        
        if roundsPlayed >= 10 {
            showFinalScoreAlert = true
        }
        
        // Trigger animation
        animateEmoji = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            animateEmoji = false
        }
    }
    
    func resetGame() {
        userScore = 0
        roundsPlayed = 0
        botMove = RPSMove.allCases.randomElement()!
        userGoal = Bool.random() ? .win : .lose
    }
}

#Preview {
    ContentView()
}
