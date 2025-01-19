import SwiftUI

struct PageTranslator: ViewModifier {
    @EnvironmentObject private var translationManager: TranslationManager
    
    func body(content: Content) -> some View {
        content
            .id(translationManager.currentLanguage) // Force view update when language changes
            .onAppear {
                translateViewTexts()
            }
            .onChange(of: translationManager.currentLanguage) { _ in
                translateViewTexts()
            }
    }
    
    private func translateViewTexts() {
        Task {
            await MainActor.run {
                translationManager.objectWillChange.send()
            }
        }
    }
}

extension View {
    func translatePage() -> some View {
        self.modifier(PageTranslator())
    }
}

// Helper View to wrap Text with translation
struct TranslatableTextWrapper: View {
    let originalText: String
    @EnvironmentObject private var translationManager: TranslationManager
    @State private var translatedText: String?
    
    var body: some View {
        Text(translatedText ?? originalText)
            .onAppear {
                translate()
            }
            .onChange(of: translationManager.currentLanguage) { _ in
                translate()
            }
    }
    
    private func translate() {
        Task {
            let result = await translationManager.translate(originalText)
            await MainActor.run {
                translatedText = result
            }
        }
    }
}

extension Text {
    func translated() -> some View {
        let originalText = self.toString()
        return TranslatableTextWrapper(originalText: originalText)
    }
    
    private func toString() -> String {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let text = child.value as? String {
                return text
            }
        }
        return ""
    }
}
