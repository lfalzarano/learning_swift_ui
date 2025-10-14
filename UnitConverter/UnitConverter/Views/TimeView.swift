//
//  TimeView.swift
//  UnitConverter
//
//  Created by Logan Falzarano on 10/13/25.
//

import SwiftUI

struct TimeView: ConversionView {
    enum Measurement: String, CaseIterable {
        case seconds = "Seconds"
        case minutes = "Minutes"
        case hours = "Hours"
        case days = "Days"
    }
    
    @State private var inputValue: String = ""
    @State private var fromUnit: Measurement = .seconds
    @State private var toUnit: Measurement = .minutes
    
    var measurements: [Measurement] {
        Measurement.allCases
    }
    
    func convert(_ value: Double, from: Measurement, to: Measurement) -> Double {
        let seconds: Double
        
        // Convert input to seconds
        switch from {
        case .seconds:
            seconds = value
        case .minutes:
            seconds = value * 60
        case .hours:
            seconds = value * 3600
        case .days:
            seconds = value * 86400
        }
        
        // Convert from seconds to target
        switch to {
        case .seconds:
            return seconds
        case .minutes:
            return seconds / 60
        case .hours:
            return seconds / 3600
        case .days:
            return seconds / 86400
        }
    }
    
    var body: some View {
        Section("Time Conversion") {
            TextField("Enter value", text: $inputValue)
                .keyboardType(.decimalPad)
            
            Picker("From", selection: $fromUnit) {
                ForEach(measurements, id: \.self) { unit in
                    Text(unit.rawValue).tag(unit)
                }
            }
            
            Picker("To", selection: $toUnit) {
                ForEach(measurements, id: \.self) { unit in
                    Text(unit.rawValue).tag(unit)
                }
            }
            
            if let value = Double(inputValue) {
                let result = convert(value, from: fromUnit, to: toUnit)
                Text("Result: \(String(format: "%.2f", result)) \(toUnit.rawValue)")
                    .fontWeight(.semibold)
            }
        }
    }
}
