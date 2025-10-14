//
//  TemperatureView.swift
//  UnitConverter
//
//  Created by Logan Falzarano on 10/13/25.
//

import SwiftUI

struct TemperatureView: ConversionView {
    enum Measurement: String, CaseIterable {
        case celsius = "Celsius"
        case fahrenheit = "Fahrenheit"
        case kelvin = "Kelvin"
    }
    
    @State private var inputValue: String = ""
    @State private var fromUnit: Measurement = .celsius
    @State private var toUnit: Measurement = .fahrenheit
    
    var measurements: [Measurement] {
        Measurement.allCases
    }
    
    func convert(_ value: Double, from: Measurement, to: Measurement) -> Double {
        let celsius: Double
        
        // Convert input to Celsius
        switch from {
        case .celsius:
            celsius = value
        case .fahrenheit:
            celsius = (value - 32) * 5/9
        case .kelvin:
            celsius = value - 273.15
        }
        
        // Convert from Celsius to target
        switch to {
        case .celsius:
            return celsius
        case .fahrenheit:
            return celsius * 9/5 + 32
        case .kelvin:
            return celsius + 273.15
        }
    }
    
    var body: some View {
        Section("Temperature Conversion") {
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
        .textCase(nil)
    }
}
