//
//  SwiftUIView.swift
//  Tasbeeh Watch App
//
//  Created by Imam Sutria on 15/03/25.
//

import SwiftUI

struct TasbeehView: View {
    
    @State private var counter = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.0, green: 0.371, blue: 0.393))
                        .frame(width: 160, height: 160)
                    
                    Circle()
                        .fill(Color(red: -0.003, green: 0.438, blue: 0.456))
                        .frame(width: 130, height: 130)
                    
                    Text(convertToArabic(counter))
                        .font(.system(size: 56))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.998, green: 0.755, blue: 0.708))
                    
                    Button(action: {
                        
                        counter += 1
                        WKInterfaceDevice.current().play(.click)
                        
                        print(convertToArabic(counter))
                        
                    }, label: {
                        Capsule()
                            .frame(width: 130, height: 130)
                            .foregroundColor(Color(red: -0.003, green: 0.438, blue: 0.456))
                            .opacity(0.1)
                    }).buttonStyle(.plain)
                }
            }
        }.navigationTitle("Tasbëëh")
    }
    // ✅ Convert Western numbers to Arabic numerals
    func convertToArabic(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "ar") // Arabic locale
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}


#Preview {
    TasbeehView()
}
