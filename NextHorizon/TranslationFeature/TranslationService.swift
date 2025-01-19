//
//  TranslationService.swift
//  NextHorizon
//
//  Created by Omar Al dulaimi on 2025-01-18.
//

import Foundation

class TranslationService {
    static let shared = TranslationService()
    private let apiKey = "AIzaSyDuDiKzfiYVoXL_HmxGKjq88d7gAkY9BaY"
    private let baseURL = "https://translation.googleapis.com/language/translate/v2"
    
    private init() {}
    
    // Fetch supported languages
    func fetchSupportedLanguages(target: String = "en") async throws -> [Language] {
        print("Fetching supported languages...")

        var components = URLComponents(string: "\(baseURL)/languages")!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "target", value: target)
        ]
        
        let (data, _) = try await URLSession.shared.data(from: components.url!)
        let response = try JSONDecoder().decode(LanguagesResponse.self, from: data)
        return response.data.languages
    }
    
    // Translate text
    func translate(_ text: String, to targetLanguage: String) async throws -> String {
        print("Translating text: \(text) to language: \(targetLanguage)")

        if targetLanguage == "en" { return text }
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [URLQueryItem(name: "key", value: apiKey)]
        
        let body: [String: Any] = [
            "q": text,
            "target": targetLanguage,
            "format": "text"
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(TranslationResponse.self, from: data)
        return response.data.translations.first?.translatedText ?? text
    }
}

// Response models
struct Language: Codable, Identifiable {
    let language: String
    let name: String
    var id: String { language }
}

struct LanguagesResponse: Codable {
    let data: LanguagesData
}

struct LanguagesData: Codable {
    let languages: [Language]
}

struct TranslationResponse: Codable {
    let data: TranslationData
}

struct TranslationData: Codable {
    let translations: [Translation]
}

struct Translation: Codable {
    let translatedText: String
}
