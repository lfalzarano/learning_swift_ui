//
//  ContentView.swift
//  WordScramble
//
//  Created by Logan Falzarano on 10/28/25.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var score = 0
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                        
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(onWordSubmit)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK") {}
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Score: \(score)")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("New Word") {
                        startGame()
                    }
                }
            }
        }
    }
    
    func isValidWord(_ answer: String) -> Bool {
        
        guard answer.count > 0 else { return false }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return false
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return false
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return false
        }
        
        guard isSufficientlyLong(word: answer) else {
            wordError(title: "Word too short", message: "Word must be at least 3 letters!")
            return false
        }
        
        guard isNotStartingWord(word: answer) else {
            wordError(title: "Word is the starting word", message: "You can be more creative than that")
            return false
        }
        
        return true
    }
    
    func wordScore(for word: String) -> Int {
        word.count
    }
    
    func onWordSubmit() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if isValidWord(answer) {
            withAnimation {
                usedWords.insert(answer, at: 0)
            }
            score += wordScore(for: answer)
            newWord = ""
        }
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8) {
                let allWords = startWords.split(separator: "\n")
                rootWord = String(allWords.randomElement() ?? "silkworm")
                usedWords = []
                score = 0
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for character in word {
            if let index = tempWord.firstIndex(of: character) {
                tempWord.remove(at: index)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func isSufficientlyLong(word: String) -> Bool {
        word.count > 2
    }
    
    func isNotStartingWord(word: String) -> Bool {
        word != rootWord
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }

}

#Preview {
    ContentView()
}
