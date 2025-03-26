//
//  Color+Hex.swift
//  SwiftCalculator
//
//  Created by StudentPM on 3/14/25.
//

import Foundation

import SwiftUI


//Evan helped me in this part lol
extension Color {

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0

        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b, a: Double
        switch hex.count {

        case 6: // RGB (No alpha)
            r = Double((int >> 16) & 0xFF) / 255.0
            g = Double((int >> 8) & 0xFF) / 255.0
            b = Double(int & 0xFF) / 255.0
            a = 1.0

        case 8: // RGBA (With alpha)
            r = Double((int >> 24) & 0xFF) / 255.0
            g = Double((int >> 16) & 0xFF) / 255.0
            b = Double((int >> 8) & 0xFF) / 255.0
            a = Double(int & 0xFF) / 255.0
            
        default:
            r = 0
            g = 0
            b = 0
            a = 1.0
        }
        self = Color(red: r, green: g, blue: b, opacity: a)

    }

}
