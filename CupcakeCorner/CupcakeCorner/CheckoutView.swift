//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Logan Falzarano on 11/26/25.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var errorMessage = ""
    @State private var showingError: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                        image
                            .resizable()
                            .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)

                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)

                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
        .alert("There was an error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            errorMessage = "Failed to encode order data"
            showingError = true
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("reqres-free-v1", forHTTPHeaderField: "X-API-Key")
        request.httpMethod = "POST"  // Don't forget this!
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: request, from: encoded)
            
            // Check HTTP status code
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "Invalid response from server"
                showingError = true
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                errorMessage = "Server error: HTTP \(httpResponse.statusCode)"
                showingError = true
                return
            }
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
            
        } catch let decodingError as DecodingError {
            errorMessage = "Failed to process server response"
            showingError = true
            print("Decoding error: \(decodingError)")
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                errorMessage = "No internet connection"
            case .timedOut:
                errorMessage = "Request timed out"
            case .cannotFindHost, .cannotConnectToHost:
                errorMessage = "Cannot connect to server"
            default:
                errorMessage = "Network error: \(urlError.localizedDescription)"
            }
            showingError = true
        } catch {
            errorMessage = "An unexpected error occurred"
            showingError = true
            print("Error: \(error)")
        }
    }
}

#Preview {
    CheckoutView(order: Order())
}
