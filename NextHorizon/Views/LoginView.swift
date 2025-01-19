//
//  LoginView.swift
//  NextHorizon
//
//  Created by Omar Al dulaimi on 2025-01-18.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var translationManager: TranslationManager
    let login: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "graduationcap.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
                .padding(.bottom, 40)
            
            TranslatableText(text: "NextHorizon")
                .font(.largeTitle)
                .bold()
            
            TranslatableText(text: "Your Academic Journey Starts Here")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 40)
            
            Button(action: login) {
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                    TranslatableText(text: "Sign In")
                }
                .frame(minWidth: 200)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .translatePage()
    }
}

