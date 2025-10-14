//
//  ContentView.swift
//  UnitConverter
//
//  Created by Logan Falzarano on 10/13/25.
//

import SwiftUI

struct ContentView: View {
    @State private var typeOfConversion: ConversionType = .temp
    
    @ViewBuilder
    var conversionView: some View { //could change to ConversionView
        switch typeOfConversion {
        case .temp:
            TemperatureView()
        case .length:
            LengthView()
        case .time:
            TimeView()
        case .volume:
            VolumeView()
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("What type of conversion would you like to make?") {
                    Picker("Conversion Type", selection: $typeOfConversion) {
                        ForEach(ConversionType.allCases, id: \.self) { conversionType in
                            Text(conversionType.rawValue).tag(conversionType)
                        }
                    }
                }
                .textCase(nil)
                
                conversionView
            }
        }
    }
}

#Preview {
    ContentView()
}
