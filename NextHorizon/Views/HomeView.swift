//
//  HomeView.swift
//  NextHorizon
//
//  Created by Omar Al dulaimi on 2025-01-18.
//

import Foundation
import SwiftUI
struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to NextHorizon")
                    .font(.title)
                    .padding()
                
                Text("Your academic assistant for a better learning experience")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }
}
