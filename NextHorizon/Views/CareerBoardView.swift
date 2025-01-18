//
//  CareerBoardView.swift
//  NextHorizon
//
//  Created by Omar Al dulaimi on 2025-01-18.
//

import Foundation
import SwiftUI
struct CareerBoardView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Career Development")
                    .font(.title)
                    .padding()
                
                Text("Coming soon: Career resources and guidance")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .navigationBarTitle("Career Board", displayMode: .inline)
        }
    }
}
