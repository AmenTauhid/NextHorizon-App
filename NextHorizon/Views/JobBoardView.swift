//
//  JobBoardView.swift
//  NextHorizon
//
//  Created by Omar Al dulaimi on 2025-01-18.
//

import Foundation
import SwiftUI

struct JobBoardView: View {
    @EnvironmentObject private var translationManager: TranslationManager
    @State private var translatedTitle: String = "Job Board"
    
    var body: some View {
        NavigationView {
            VStack {
                TranslatableText(text: "Find Your Next Opportunity")
                    .font(.title)
                    .padding()
                
                TranslatableText(text: "Coming soon: Student job listings and internships")
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
            translatedTitle = await translationManager.translate("Job Board")
        }
    }
}
