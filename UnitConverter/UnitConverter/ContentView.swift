//
//  ContentView.swift
//  UnitConverter
//
//  Created by Logan Falzarano on 10/13/25.
//

import SwiftUI

enum ConversionType: String, CaseIterable {
    case temp = "Temperature"
    case length = "Length"
    case time = "Time"
    case volume = "Volume"
}

protocol ConversionView: View {
    associatedtype Measurement
    
    var measurements: [Measurement] { get }
    func convert(_ value: Double, from: Measurement, to: Measurement) -> Double
}

struct TemperatureView: ConversionView {
    enum MeasurementType: String, CaseIterable {
        case celsius = "Celsius"
        case fahrenheit = "Fahrenheit"
        case kelvin = "Kelvin"
    }
    
    @State private var inputValue: String = ""
    @State private var fromUnit: MeasurementType = .celsius
    @State private var toUnit: MeasurementType = .fahrenheit
    
    var measurements: [MeasurementType] {
        MeasurementType.allCases
    }
    
    func convert(_ value: Double, from: MeasurementType, to: MeasurementType) -> Double {
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
    }
}

struct ContentView: View {
    @State private var typeOfConversion: ConversionType = .temp
    
    @ViewBuilder
    var conversionView: some View { //could change to ConversionView
        switch typeOfConversion {
        case .temp:
            TemperatureView()
        case .length:
            Section("Length Conversion") {
                Text("Length view here")
            }
        case .time:
            Section("Length Conversion") {
                Text("Length view here")
            }
        case .volume:
            Section("Length Conversion") {
                Text("Length view here")
            }
        }
    }
    
    var body: some View {
        NavigationView{
            Form {
                Section("What kind of conversion would you like to make?") {
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
