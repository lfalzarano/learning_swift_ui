//
//  ConversionView.swift
//  UnitConverter
//
//  Created by Logan Falzarano on 10/13/25.
//

import SwiftUI

protocol ConversionView: View {
    associatedtype Measurement
    
    var measurements: [Measurement] { get }
    func convert(_ value: Double, from: Measurement, to: Measurement) -> Double
}
