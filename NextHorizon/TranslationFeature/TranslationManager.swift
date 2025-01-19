//
//  TranslationManager.swift
//  NextHorizon
//
//  Created by Omar Al dulaimi on 2025-01-18.
//import Foundation
import SwiftUI

@MainActor
class TranslationManager: ObservableObject {
    static let shared = TranslationManager()
    private let service = TranslationService.shared
    private let defaults = UserDefaults.standard
    
    @Published var currentLanguage: String {
        didSet {
            defaults.set(currentLanguage, forKey: "PreferredLanguage")
            Task { @MainActor in
                translationCache.removeAll()
                objectWillChange.send()
            }
        }
    }
    
    @Published private(set) var availableLanguages: [Language] = []
    @Published private(set) var isLoadingLanguages = false
    @Published private(set) var loadingError: String?
    
    private var translationCache: [String: String] = [:]
    private var translationTasks: [String: Task<String, Error>] = [:]
    
    private init() {
        self.currentLanguage = defaults.string(forKey: "PreferredLanguage") ?? "en"
        Task { @MainActor in
            await loadLanguages()
        }
    }
    
    private func loadLanguages() async {
        guard availableLanguages.isEmpty else { return }
        
        isLoadingLanguages = true
        loadingError = nil
        
        do {
            let languages = try await service.fetchSupportedLanguages()
            await MainActor.run {
                self.availableLanguages = languages
                self.isLoadingLanguages = false
            }
        } catch {
            await MainActor.run {
                self.loadingError = error.localizedDescription
                self.isLoadingLanguages = false
            }
            print("Error loading languages: \(error)")
        }
    }
    
    func translate(_ text: String) async -> String {
        // Return original if language is English or text is empty
        guard !text.isEmpty, currentLanguage != "en" else {
            return text
        }
        
        // Check cache first
        if let cached = translationCache[text] {
            return cached
        }
        
        // Check if there's already a translation task for this text
        if let existingTask = translationTasks[text] {
            do {
                return try await existingTask.value
            } catch {
                print("Translation task error: \(error)")
                return text
            }
        }
        
        // Create a new translation task
        let task = Task { () throws -> String in
            defer { translationTasks.removeValue(forKey: text) }
            
            do {
                let translated = try await service.translate(text, to: currentLanguage)
                await MainActor.run {
                    self.translationCache[text] = translated
                }
                return translated
            } catch {
                print("Translation error: \(error)")
                throw error
            }
        }
        
        translationTasks[text] = task
        
        do {
            return try await task.value
        } catch {
            return text
        }
    }
    
    func clearCache() {
        Task { @MainActor in
            translationCache.removeAll()
            // Cancel all pending translation tasks
            for task in translationTasks.values {
                task.cancel()
            }
            translationTasks.removeAll()
        }
    }
    
    func refreshLanguages() async {
        await loadLanguages()
    }
    
    deinit {
        // Cancel all pending tasks
        for task in translationTasks.values {
            task.cancel()
        }
    }
}
