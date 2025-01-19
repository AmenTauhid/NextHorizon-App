//
//  JobBoardView.swift
//  NextHorizon
//

import Foundation
import SwiftUI

struct JobBoardView: View {
    @EnvironmentObject private var translationManager: TranslationManager
    @State private var translatedTitle: String = "Job Board"
    
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
                    TranslatableText(text: "Find Your Next Opportunity")
                        .font(.title)
                        .padding()
                    
                    TranslatableText(text: "Coming soon: Student job listings and internships")
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
            translatedTitle = await translationManager.translate("Job Board")
        }
    }
}
