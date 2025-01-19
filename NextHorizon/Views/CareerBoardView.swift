//
//  CareerBoardView.swift
//  NextHorizon
//

import Foundation
import SwiftUI

struct CareerBoardView: View {
    @EnvironmentObject private var translationManager: TranslationManager
    @State private var translatedTitle: String = "Career Board"
    
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
                    TranslatableText(text: "Career Development")
                        .font(.title)
                        .padding()
                    
                    TranslatableText(text: "Coming soon: Career resources and guidance")
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
            translatedTitle = await translationManager.translate("Career Board")
        }
    }
}
