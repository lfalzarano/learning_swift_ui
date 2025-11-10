//
//  ContentView.swift
//  Moonshot
//
//  Created by Logan Falzarano on 11/9/25.
//

import SwiftUI

struct ContentView: View {
    let astronauts = Bundle.main.decode("astronauts.json")
    
    var body: some View {
        Text(String(astronauts.count))
    }
}

#Preview {
    ContentView()
}
