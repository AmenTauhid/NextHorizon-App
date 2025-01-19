//
//  TranslatableText.swift
//  NextHorizon
//
//  Created by Omar Al dulaimi on 2025-01-18.
//

import Foundation
import SwiftUI

struct TranslatableText: View {
    let text: String
    @EnvironmentObject private var translationManager: TranslationManager  
    @State private var translatedText: String?
    
    var body: some View {
        Text(translatedText ?? text)
            .onAppear {
                translate()
            }
            .onChange(of: translationManager.currentLanguage) { _ in
                translate()
            }
    }
    
    private func translate() {
        Task {
            let result = await translationManager.translate(text)
            DispatchQueue.main.async {
                translatedText = result
            }
        }
    }
}

extension View {
    func translated(_ text: String) -> some View {
        TranslatableText(text: text)
    }
}
