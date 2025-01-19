//
//  HomeView.swift
//  NextHorizon
//

import Foundation
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var translationManager: TranslationManager
    @State private var translatedTitle: String = "Home"
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    TranslatableText(text: "Welcome to NextHorizon")
                        .font(.title)
                        .padding()
                    
                    TranslatableText(text: "Your academic assistant for a better learning experience")
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .navigationBarTitle(translatedTitle)
                .onAppear {
                    translateNavigationTitle()
                }
                .onChange(of: translationManager.currentLanguage) { _ in
                    translateNavigationTitle()
                }
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
