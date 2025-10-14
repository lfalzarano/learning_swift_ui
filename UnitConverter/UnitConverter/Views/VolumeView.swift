//
//  VolumeView.swift
//  UnitConverter
//
//  Created by Logan Falzarano on 10/13/25.
//

import SwiftUI

struct VolumeView: ConversionView {
    enum Measurement: String, CaseIterable {
        case liters = "Liters"
        case milliliters = "Milliliters"
        case gallons = "Gallons"
        case cups = "Cups"
    }
    
    @State private var inputValue: String = ""
    @State private var fromUnit: Measurement = .liters
    @State private var toUnit: Measurement = .gallons
    
    var measurements: [Measurement] {
        Measurement.allCases
    }
    
    func convert(_ value: Double, from: Measurement, to: Measurement) -> Double {
        let liters: Double
        
        // Convert input to liters
        switch from {
        case .liters:
            liters = value
        case .milliliters:
            liters = value / 1000
        case .gallons:
            liters = value * 3.78541
        case .cups:
            liters = value * 0.236588
        }
        
        // Convert from liters to target
        switch to {
        case .liters:
            return liters
        case .milliliters:
            return liters * 1000
        case .gallons:
            return liters / 3.78541
        case .cups:
            return liters / 0.236588
        }
    }
    
    var body: some View {
        Section("Volume Conversion") {
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
