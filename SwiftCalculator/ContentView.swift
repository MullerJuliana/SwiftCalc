//
//  ContentView.swift
//  SwiftCalculator
//
//  Created by StudentPM on 3/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var screenNumber: String = "0"  // Stores the number displayed on screen
    @State private var expression: String = "" // Stores the full expression
    @State private var buttonOperator: Bool = false // Stops operators from being next to each other
    
    @State private var numsAndOperations: [[String]] = [
        // 2D array for calculator layout
        ["AC", "+/-", "%", "÷"],
        ["7", "8", "9", "x"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    
    var body: some View {
        VStack {
            Color.black // Set background color
                .ignoresSafeArea() // Extends the background color to the whole screen
            
            VStack(alignment: .trailing) {
                Text(formatNumber(screenNumber)) // Display the current number with commas
                    .foregroundColor(.white) // White color for display
                    .font(.system(size: 80)) // Size for display number/default zero
                    .padding()
                
                // Loop through each row of buttons
                ForEach(numsAndOperations, id: \.self) { row in
                    HStack {
                        // Loop through each button in the row
                        ForEach(row, id: \.self) { text in
                            ButtonsView(cardText: text, action: {
                                buttonTapped(text) // Calls buttonTapped function when pressed
                            })
                        }
                    }
                }
            }
        }
        .background(Color.black) // Sets the background color to black
    }
    
    // Function to format numbers with commas
    func formatNumber(_ number: String) -> String {
        if let num = Double(number) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: num)) ?? number
        }
        return number
    }
    
    // Function every time a button is pressed
    func buttonTapped(_ text: String) {
        if text == "AC" { // Reset calculator
            screenNumber = "0"
            expression = ""
            buttonOperator = false
        } else if text == "%" { // Convert to percentage
            if let number = Double(screenNumber) {
                screenNumber = String(number / 100) // Divide by 100 to get percentage
                expression = ""
            }
        } else if text == "+/-" { // Toggle positive/negative
            if let number = Double(screenNumber) {
                screenNumber = String(number * -1) // Multiply by -1 to toggle sign
                expression = ""
            }
        } else if ["÷", "x", "-", "+"].contains(text) {
            if !buttonOperator { // Prevent multiple consecutive operators
                expression += " \(text) " // Append operator with spacing for clarity
                buttonOperator = true // Mark last pressed as operator
            }
        } else {
            if screenNumber == "0" || buttonOperator {
                screenNumber = text // Replace 0 with the first number pressed
            } else {
                // Allow more digits to be added
                screenNumber += text // Adds pressed number
            }
            buttonOperator = false // Reset operator flag after a number is entered
        }
    }
}

#Preview {
    ContentView()
}

