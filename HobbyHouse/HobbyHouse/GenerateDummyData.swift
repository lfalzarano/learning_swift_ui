//
//  GenerateDummyData.swift
//  HobbyHouse
//
//  Created by Logan Falzarano on 11/23/25.
//

import Foundation

func generateDummyData() -> [Hobby] {
    let calendar = Calendar.current
    let today = Date()
    
    return [
        Hobby(
            name: "Guitar Practice",
            description: "Learning to play acoustic guitar and improve my skills with daily practice sessions",
            startDate: calendar.date(byAdding: .day, value: -45, to: today)!,
            hobbyNotes: [
                HobbyNotes(date: today, note: "Practiced C, G, D chords for 30 minutes"),
                HobbyNotes(date: calendar.date(byAdding: .day, value: -1, to: today)!, note: "Worked on finger positioning and transitions"),
                HobbyNotes(date: calendar.date(byAdding: .day, value: -2, to: today)!, note: "Learned new strumming pattern"),
                HobbyNotes(date: calendar.date(byAdding: .day, value: -4, to: today)!, note: "Practiced scales for 20 minutes"),
                HobbyNotes(date: calendar.date(byAdding: .day, value: -6, to: today)!, note: "First attempt at playing a full song")
            ]
        ),
        Hobby(
            name: "Morning Yoga",
            description: "Daily yoga routine for flexibility, strength, and mindfulness",
            startDate: calendar.date(byAdding: .day, value: -20, to: today)!,
            hobbyNotes: [
                HobbyNotes(date: today, note: "20 minute vinyasa flow - feeling great!"),
                HobbyNotes(date: calendar.date(byAdding: .day, value: -1, to: today)!, note: "Focused on hip openers today"),
                HobbyNotes(date: calendar.date(byAdding: .day, value: -3, to: today)!, note: "Morning stretch routine, 15 minutes")
            ]
        ),
        Hobby(
            name: "Watercolor Painting",
            description: "Exploring watercolor techniques and landscape painting",
            startDate: calendar.date(byAdding: .day, value: -60, to: today)!,
            hobbyNotes: [
                HobbyNotes(date: calendar.date(byAdding: .day, value: -1, to: today)!, note: "Painted a sunset scene - colors turned out beautiful"),
                HobbyNotes(date: calendar.date(byAdding: .day, value: -5, to: today)!, note: "Practiced wet-on-wet technique")
            ]
        ),
        Hobby(
            name: "French Language",
            description: "Learning French through daily practice and conversation",
            startDate: calendar.date(byAdding: .day, value: -90, to: today)!,
            hobbyNotes: [
                HobbyNotes(date: today, note: "Completed lesson 15 on Duolingo"),
                HobbyNotes(date: calendar.date(byAdding: .day, value: -1, to: today)!, note: "Practiced verb conjugations for 30 minutes"),
                HobbyNotes(date: calendar.date(byAdding: .day, value: -2, to: today)!, note: "Watched French movie with subtitles"),
                HobbyNotes(date: calendar.date(byAdding: .day, value: -3, to: today)!, note: "Had conversation practice with language partner"),
                HobbyNotes(date: calendar.date(byAdding: .day, value: -4, to: today)!, note: "Learned 20 new vocabulary words"),
                HobbyNotes(date: calendar.date(byAdding: .day, value: -5, to: today)!, note: "Read French article about cooking"),
                HobbyNotes(date: calendar.date(byAdding: .day, value: -6, to: today)!, note: "Grammar exercises - past tense")
            ]
        ),
        Hobby(
            name: "Running",
            description: "Training for a 5K race",
            startDate: calendar.date(byAdding: .day, value: -14, to: today)!,
            hobbyNotes: [
                HobbyNotes(date: today, note: "3 mile run - new personal best time!"),
                HobbyNotes(date: calendar.date(byAdding: .day, value: -2, to: today)!, note: "Easy 2 mile jog around the park")
            ]
        ),
        Hobby(
            name: "Baking",
            description: "Experimenting with sourdough and pastries",
            startDate: calendar.date(byAdding: .day, value: -30, to: today)!,
            hobbyNotes: [
                HobbyNotes(date: calendar.date(byAdding: .day, value: -3, to: today)!, note: "Fed sourdough starter")
            ]
        )
    ]
}
