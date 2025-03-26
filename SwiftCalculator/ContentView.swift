//
//  ContentView.swift
//  SwiftCalculator
//
//  Created by StudentPM on 3/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var screenNumber: String = "0"  // Stores the number displayed on the screen
    @State private var expression: String = "" // Stores the full expression for calculation
    @State private var buttonOperator: Bool = false // Tracks whether the last button pressed was an operator
    
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
                // Display the current number formatted with commas
                Text(formatNumber(screenNumber))
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
    
    // Function to format numbers with commas for readability
    func formatNumber(_ number: String) -> String {
        if let num = Double(number) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: num)) ?? number
        }
        return number
    }
    
    // Function executed every time a button is pressed
    func buttonTapped(_ text: String) {
        if text == "AC" { // Reset calculator when "AC" is pressed
            screenNumber = "0" // Reset screen number to 0
            expression = "" // Clear the expression
            buttonOperator = false // Reset operator flag
        } else if text == "%" { // Convert to percentage when "%" is pressed
            if let number = Double(screenNumber) {
                screenNumber = String(number / 100) // Divide by 100 to get percentage
                expression = "" // Clear expression after percentage calculation
            }
        } else if text == "+/-" { // Toggle positive/negative when "+/-" is pressed
            if let number = Double(screenNumber) {
                screenNumber = String(number * -1) // Multiply by -1 to toggle sign
                expression = "" // Clear expression
            }
        } else if ["÷", "x", "-", "+"].contains(text) {
            // Handle operator input
            if !buttonOperator { // Prevent multiple consecutive operators
                expression += " \(screenNumber) \(text)" // Append current screen number and operator
                buttonOperator = true // Mark last pressed as operator
                screenNumber = "0" // Reset screen number for the next input
            }
        } else if text == "=" {
            // Calculate the result when "=" is pressed
            expression += " \(screenNumber)" // Append the last number to the expression
            if let result = calculateResult(expression) {
                screenNumber = String(result) // Update screen number with the result
                expression = "" // Clear the expression after calculation
            }
        } else {
            // Handle number input
            if screenNumber == "0" || buttonOperator {
                screenNumber = text // Replace 0 with the first number pressed
            } else {
                screenNumber += text // Adds pressed number to the existing number
            }
            buttonOperator = false // Reset operator flag after a number is entered
        }
    }
    
    // Function to calculate the result of the expression
    func calculateResult(_ expression: String) -> Double? {
        // Replace 'x' with '*' and '÷' with '/' for easier evaluation
        let cleanedExpression = expression.replacingOccurrences(of: "x", with: "*").replacingOccurrences(of: "÷", with: "/")
        
        // Split the expression into components (numbers and operators)
        let expressionComponents = cleanedExpression.split(separator: " ").map { String($0) }
        
        var total: Double = 0 // Variable to store the total result
        var currentOperation: String = "+" // Start with addition as the default operation
        var currentValue: Double = 0 // Variable to store the current number
        
        // Loop through each component of the expression
        for component in expressionComponents {
            if let value = Double(component) {
                currentValue = value // Update the current value with the number
            } else {
                // Perform the previous operation with the current total and current value
                switch currentOperation {
                case "+":
                    total += currentValue
                case "-":
                    total -= currentValue
                case "*":
                    total *= currentValue
                case "/":
                    // Check for division by zero
                    total = currentValue != 0 ? total / currentValue : 0
                default:
                    break
                }
                currentOperation = component // Update the current operation
            }
        }
        
        // Perform the last operation after the loop
        switch currentOperation {
        case "+":
            total += currentValue
        case "-":
            total -= currentValue
        case "*":
            total *= currentValue
        case "/":
            // Check for division by zero
            total = currentValue != 0 ? total / currentValue : 0
        default:
            break
        }
        
        return total // Return the final calculated total
    }
}

#Preview {
    ContentView()
}


