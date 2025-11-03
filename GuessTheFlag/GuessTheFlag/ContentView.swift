import SwiftUI

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore: Bool = false
    @State private var scoreTitle: String = ""
    @State private var score: Int = 0
    @State private var questionsAnswered: Int = 0
    @State private var showingFinalScore: Bool = false
    //separate variables to make tapped flag and non-tapped flag
    //animations independent
    @State private var tappedFlagRotationEffect: Int?
    @State private var tappedFlagFadeEffect: Int?
    @State private var spinAmount = 0.0
    @State private var fadeFlag: Bool = false
    
    let numberOfQuestions: Int = 8
    
    var questionRemaining: Int {
        numberOfQuestions - self.questionsAnswered
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color.blue.opacity(0.5), location: 0.0),
                .init(color: Color.blue, location: 0.2),
                .init(color: Color.blue.opacity(0.5), location: 1.0)
            ], center: .top, startRadius: 200, endRadius: 900)
            .ignoresSafeArea(edges: .all)
            VStack {
                Spacer()
                
                Text("Guess the flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                
                Spacer()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.bold))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.secondary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                        }
                        .rotation3DEffect(.degrees(tappedFlagRotationEffect == number ? spinAmount : 0), axis: (x: 0, y: 1, z: 0))
                        .opacity(fadeFlag && tappedFlagFadeEffect != number ? 0.3 : 1.0)
                        .scaleEffect(fadeFlag && tappedFlagFadeEffect != number ? 0.5 : 1.0)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 40))
                
                Text("Questions Remaining: \(questionRemaining)")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.secondary)
                    .padding(10) // padding
                    .background(.regularMaterial.opacity(0.5))
                    .clipShape(Capsule())
                    .padding(.top, 10) // only pad top so space to Score is equal to Guess the flag
                
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.largeTitle.weight(.bold))
                
                Spacer()
            }
            .padding(20)
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Next question") {
                self.askAnotherQuestion()
            }
        } message: {
            Text("Your score is: \(score)")
        }
        .alert("Game over!", isPresented: $showingFinalScore) {
            Button("Play again") {
                resetGame()
            }
        } message: {
            Text("Your score is: \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        tappedFlagRotationEffect = number
        tappedFlagFadeEffect = number
        
        withAnimation {
            spinAmount += 360
        }
        withAnimation {
            fadeFlag = true
        }
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = """
            Wrong!
            That's the flag of \(countries[correctAnswer])
            """
        }
        
        questionsAnswered += 1
        
        if questionsAnswered >= numberOfQuestions {
            showingFinalScore = true
        } else {
            showingScore = true
        }
    }
    
    func askAnotherQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        showingScore = false
        
        withAnimation {
            tappedFlagFadeEffect = nil
            fadeFlag = false
        }
        
        tappedFlagRotationEffect = nil
        spinAmount = 0
    }
    
    func resetGame() {
        score = 0
        questionsAnswered = 0
        tappedFlagFadeEffect = nil
        tappedFlagRotationEffect = nil
        spinAmount = 0
        fadeFlag = false
        askAnotherQuestion()
    }
}

#Preview {
    ContentView()
}
