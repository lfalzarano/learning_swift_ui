//
//  LengthView.swift
//  UnitConverter
//
//  Created by Logan Falzarano on 10/13/25.
//

import SwiftUI

struct LengthView: ConversionView {
    enum Measurement: String, CaseIterable {
        case meters = "Meters"
        case kilometers = "Kilometers"
        case feet = "Feet"
        case miles = "Miles"
    }
    
    @State private var inputValue: String = ""
    @State private var fromUnit: Measurement = .meters
    @State private var toUnit: Measurement = .feet
    
    var measurements: [Measurement] {
        Measurement.allCases
    }
    
    func convert(_ value: Double, from: Measurement, to: Measurement) -> Double {
        let meters: Double
        
        // Convert input to meters
        switch from {
        case .meters:
            meters = value
        case .kilometers:
            meters = value * 1000
        case .feet:
            meters = value * 0.3048
        case .miles:
            meters = value * 1609.34
        }
        
        // Convert from meters to target
        switch to {
        case .meters:
            return meters
        case .kilometers:
            return meters / 1000
        case .feet:
            return meters / 0.3048
        case .miles:
            return meters / 1609.34
        }
    }
    
    var body: some View {
        Section("Length Conversion") {
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

