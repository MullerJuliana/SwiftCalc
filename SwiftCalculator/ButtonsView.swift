//
//  iamanalpha101.swift
//  SwiftCalculator
//
//  Created by StudentPM on 3/14/25.
//

import SwiftUI

struct ButtonsView: View {
    var cardText: String = "" // Text displayed on the button
    var action: () -> Void // Action to do when button is tapped
    @State private var isPressed: Bool = false // Track if the button is pressed
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 100)
                .fill(isPressed ? .white : decideColor(text: cardText)) // Change color when pressed
                .frame(width: cardText == "0" ? 160 : 80.5, height: 80) // Adjust button size
                .onTapGesture {
                    isPressed = true // Set to true on tap
                    action() // Call action when tapped
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isPressed = false // Reset after a short delay
                    }
                }
            
            Text("\(cardText)")
                .foregroundColor(blackFont(text: cardText)) // Set text color
                .font(.title)
        }
    }
    
    // Function to determine button color based on type
    func decideColor(text: String) -> Color {
        if ["÷", "x", "-", "+", "="].contains(cardText) {
            return .orange // Operator buttons = orange
        } else if ["AC", "+/-", "%"].contains(cardText) {
            return Color(hex: "#cccccc") // Function buttons = light gray
        } else {
            return .gray // Number buttons = dark gray
        }
    }
    
    // Function to determine text color
    func blackFont(text: String) -> Color {
        if ["AC", "+/-", "%"].contains(cardText) {
            return .black // Function buttons have black text
        } else {
            return .white // Number and operator buttons have white text
        }
    }
}

#Preview {
    ContentView()
}
