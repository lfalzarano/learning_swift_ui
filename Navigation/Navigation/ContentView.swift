//
//  ContentView.swift
//  Navigation
//
//  Created by Logan Falzarano on 11/15/25.
//

import SwiftUI

struct Student: Hashable {
    var id = UUID()
    var name: String
    var age: Int
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List(0..<100) { i in
                NavigationLink("Select \(i)", value: i)
            }
            .navigationDestination(for: Int.self) { selection in
                Text("Selected: \(selection)")
            }
            .navigationDestination(for: Student.self) { student in
                Text("You Selected \(student.name)")
            }
        }
    }
}

#Preview {
    ContentView()
}
