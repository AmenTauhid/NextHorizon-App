//
//  HomeView.swift
//  NextHorizon
//
//  Created by Omar Al dulaimi on 2025-01-18.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var translationManager: TranslationManager
    @State private var translatedTitle: String = "Home"
    
    var body: some View {
        NavigationView {
            VStack {
                TranslatableText(text: "Welcome to NextHorizon")
                    .font(.title)
                    .padding()
                
                TranslatableText(text: "Your academic assistant for a better learning experience")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .navigationBarTitle(translatedTitle, displayMode: .inline)
            .onAppear {
                translateNavigationTitle()
            }
            .onChange(of: translationManager.currentLanguage) { _ in
                translateNavigationTitle()
            }
        }
        .translatePage()
    }
    
    private func translateNavigationTitle() {
        Task {
            translatedTitle = await translationManager.translate("Home")
        }
    }
}
