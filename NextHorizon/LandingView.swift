//
//  LandingView.swift
//  NextHorizon
//
//  Created by Elias Alissandratos on 2025-01-18.
//

import SwiftUI

struct LandingView: View {
    let login: () -> Void
    
    @State private var isAnimating = false
    @State private var showOptions = false
    @State private var backgroundGradient = Gradient(colors: [Color.black, Color.black])

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: backgroundGradient, startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 2), value: backgroundGradient)

                ZStack {
                    ForEach(1...5, id: \.self) { index in
                        Circle()
                            .fill(Color.yellow.opacity(0.25 / Double(index)))
                            .frame(width: CGFloat(index) * 250, height: CGFloat(index) * 250)
                            .offset(y: -50)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.easeInOut(duration: 2).delay(0.5), value: isAnimating)
                    }

                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 150, height: 150)
                        .offset(y: isAnimating ? -50 : UIScreen.main.bounds.height / 2)
                        .animation(.easeInOut(duration: 2), value: isAnimating)
                }
                .offset(y: showOptions ? -150 : -50)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .padding(.bottom, -100)

                VStack {
                    Spacer()

                    Text("NextHorizon")
                        .font(.system(size: 48, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 10, x: 5, y: 5)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeInOut(duration: 1).delay(2), value: isAnimating)

                    Text("Unlocking Careers, Expanding Horizons")
                        .font(.headline)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 10, x: 5, y: 5)
                        .opacity(showOptions ? 1 : 0)
                        .animation(.easeInOut(duration: 1).delay(0.5), value: showOptions)

                    Spacer(minLength: 120)

                    if showOptions {
                        VStack(spacing: 20) {
                            Button(action: login) {
                                Text("Log In")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color(hex: "083221"))
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal, 40)
                        .transition(.opacity)
                        .offset(y: -100)
                        .padding(.top, -100)
                    }
                }
                .zIndex(1)

            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    isAnimating = true
                    backgroundGradient = Gradient(colors: [Color.blue, Color.blue.opacity(0.6)])
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showOptions = true
                    }
                }
            }
        }
    }
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        if hexSanitized.count == 6 {
            var rgb: UInt64 = 0
            Scanner(string: hexSanitized).scanHexInt64(&rgb)
            self.init(
                .sRGB,
                red: Double((rgb >> 16) & 0xFF) / 255.0,
                green: Double((rgb >> 8) & 0xFF) / 255.0,
                blue: Double(rgb & 0xFF) / 255.0,
                opacity: 1.0
            )
        } else {
            self.init(.clear)
        }
    }
}
