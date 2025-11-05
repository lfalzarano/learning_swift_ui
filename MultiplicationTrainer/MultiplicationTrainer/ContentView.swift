//
//  ContentView.swift
//  MultiplicationTrainer
//
//  Created by Logan Falzarano on 11/3/25.
//

import SwiftUI

struct Question {
    let number1: Int
    let number2: Int
}

enum GameState {
    case selectingSettings
    case askingQuestions
    case showingScore
}

struct SettingView : View {
    @State private var numberOfQuestions: Int = 10
    @State private var multiplierBottomRange: Int = 2
    @State private var multiplierTopRange: Int = 12
    
    // closure to send return data from the view
    // this will be passed in by the parent to specify how to use the setting state
    var onConfirmSettings: (Int, Int, Int) -> Void
    
    var body: some View {
        VStack {
            Stepper("Number of Questions: \(numberOfQuestions)", value: $numberOfQuestions, in: 10...50)
            Stepper("Bottom Range: \(multiplierBottomRange)", value: $multiplierBottomRange, in: 2...12)
            Stepper("Top Range: \(multiplierTopRange)", value: $multiplierTopRange, in: 2...12)
            
            Button("Start Game") {
                onConfirmSettings(numberOfQuestions, multiplierBottomRange, multiplierTopRange)
            }
        }
        .padding()
    }
}

struct GameView: View {
    let questions: [Question]
    let numberOfQuestions: Int
    //define a closure that can reset the game state
    let restartGame: () -> Void
    @State private var currentQuestionIndex: Int = 0
    @State private var score: Int = 0
    @State private var userAnswer: String = ""
    @State private var showingAnswerResult: Bool = false
    @State private var wasAnswerCorrect: Bool = false
    @State private var showingFinalScore: Bool = false
    @State private var showingBackConfirmation: Bool = false
    
    var currentQuestion: Question {
        questions[currentQuestionIndex]
    }
    
    var body: some View {
        VStack {
            // Header with back button
            HStack {
                Button("← Back to Settings") {
                    showingBackConfirmation = true
                }
                .padding()
                
                Spacer()
            }
            
            Spacer()
            
            Text("Questions Remaining: \(showingFinalScore ? 0 : numberOfQuestions - currentQuestionIndex)")
            
            Text("Score: \(score)")
            
            Text("What is \(currentQuestion.number1) × \(currentQuestion.number2)?")
                .font(.largeTitle)
            
            TextField("Your answer", text: $userAnswer)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)  // ← Shows only numbers
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
                .onSubmit {submitAnswer()}
            
            Button("Check Answer") {
                submitAnswer()
            }
            
            Spacer()
        }
        .alert(wasAnswerCorrect ? "Correct! 🎉" : "Wrong ❌", isPresented: $showingAnswerResult) {
            Button(questions.count - 1 == currentQuestionIndex ? "Finish Game" :"Next Question") {
                showingAnswerResult = false
            }
        } message: {
            if wasAnswerCorrect {
                Text("Great job!")
            } else {
                Text("The answer was \(currentQuestion.number1 * currentQuestion.number2)")
            }
        }
        .alert("Your final score was \(score) out of \(numberOfQuestions). Play again?", isPresented: $showingFinalScore) {
            Button("Play Again") {
                //note this will create a new settings view with fresh state so we don't
                //need to explicitly reset the state
                restartGame()
            }
        }
        .alert("Are you sure you want to go back? Your progress will be lost.", isPresented: $showingBackConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Go Back", role: .destructive) {
                restartGame()
            }
        }
    }
    
    func submitAnswer() {
        let correctAnswer = currentQuestion.number1 * currentQuestion.number2
        
        //if we can cast the userAnswer to an int, check it
        if let answer = Int(userAnswer), answer == correctAnswer {
            score += 1
            wasAnswerCorrect = true
        } else {
            wasAnswerCorrect = false
        }
        
        userAnswer = ""
        
        // Check if this was the last question
        if currentQuestionIndex >= numberOfQuestions - 1 {
            showingFinalScore = true
        } else {
            currentQuestionIndex += 1  // ← Move to next question BEFORE showing alert
            showingAnswerResult = true
        }
    }
}

struct ContentView: View {
    @State private var questions: [Question] = []
    @State private var gameState: GameState = .selectingSettings
    
    //settings state
    @State private var numberOfQuestions: Int = 10
    @State private var multiplierBottomRange: Int = 2
    @State private var multiplierTopRange: Int = 12
    
    var body: some View {
        if gameState == .selectingSettings {
            SettingView(onConfirmSettings: { numberOfQuestions, multiplierBottomRange, multiplierTopRange in
                self.numberOfQuestions = numberOfQuestions
                self.multiplierBottomRange = multiplierBottomRange
                self.multiplierTopRange = multiplierTopRange
                
                generateQuestions()
                self.gameState = .askingQuestions
            })
        } else {
            GameView(questions: questions, numberOfQuestions: numberOfQuestions, restartGame: {
                gameState = .selectingSettings
            })
        }
    }
    
    func generateQuestions() {
        questions = []  // Clear old questions first
        for _ in 0..<numberOfQuestions {
            let num1 = Int.random(in: multiplierBottomRange...multiplierTopRange)
            let num2 = Int.random(in: multiplierBottomRange...multiplierTopRange)
            questions.append(Question(number1: num1, number2: num2))
        }
    }
}

#Preview {
    ContentView()
}
