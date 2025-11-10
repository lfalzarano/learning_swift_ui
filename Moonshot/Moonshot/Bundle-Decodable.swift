//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by Logan Falzarano on 11/9/25.
//

import Foundation

extension Bundle {
    func decode(_ file: String) -> [String: Astronaut] {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        
        do {
            return try decoder.decode([String: Astronaut].self, from: data)
        } catch DecodingError.keyNotFound(let key, let context){
            fatalError("Failed to decode \(file) from bundle. Missing key: \(key) -  \(context)")
        } catch DecodingError.typeMismatch(let type, let context){
            fatalError("Failed to decode \(file) from bundle. Type Mismatch: \(type) - \(context)")
        } catch DecodingError.valueNotFound(let value, let context){
            fatalError("Failed to decode \(file) from bundle. Value Not Found: \(value) - \(context)")
        } catch DecodingError.dataCorrupted(let context){
            fatalError("Failed to decode \(file) from bundle. Data Corrupted: \(context)")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}
