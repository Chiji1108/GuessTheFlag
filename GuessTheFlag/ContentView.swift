//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by 千々岩真吾 on 2024/05/17.
//

import SwiftUI

struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundStyle(.blue)
    }
}

extension View {
    func title() -> some View {
        modifier(TitleModifier())
    }
}

struct FlagImage: View {
    var image: String
    
    init(_ image: String) {
        self.image = image
    }
    
    var body: some View {
        Image(image)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
    @State private var countries = allCountries.shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var questionCounter = 1
    @State private var showingResults = false
    @State private var selectedFlag = -1
    @State private var hoge = "mario"
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .title()
                
                Text("\(hoge.count)")
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(countries[number])
                        }
                        .rotation3DEffect(selectedFlag == number ? Angle(degrees: 360) : .zero, axis: (x: 0, y: 1, z: 0))
                        .opacity((selectedFlag != number && selectedFlag != -1) ? 0.25 : 1)
                        .scaleEffect((selectedFlag != number && selectedFlag != -1) ? CGSize(width: 0.5, height: 0.5) : CGSize(width: 1, height: 1))
                        .blur(radius: selectedFlag == -1 || selectedFlag == number ? 0 : 3)
                        .saturation(selectedFlag == -1 || selectedFlag == number ? 1 : 0)
                        .animation(.bouncy, value: selectedFlag)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                VStack {
                    Text("Score: \(score)")
                }
                .foregroundStyle(.white)
                .font(.title.bold())

                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game over!", isPresented: $showingResults) {
            Button("Start Again", action: newGame)
        } message: {
            Text("Your final score was \(score).")
        }
    }
    
    func flagTapped(_ number: Int) {
        selectedFlag = number
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong!\nThat’s the flag of \(countries[number])"
        }
        if questionCounter >= 8 {
            showingResults = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.remove(at: correctAnswer)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionCounter += 1
        selectedFlag = -1
    }
    
    func newGame() {
        questionCounter = 0
        score = 0
        countries = Self.allCountries
        askQuestion()
    }
}

#Preview {
    ContentView()
}
