//
//  NextHorizonApp.swift
//  NextHorizon
//
//  Created by Ayman Tauhid on 2025-01-18.
//

import SwiftUI

@main
struct NextHorizonApp: App {
    // Initialize TranslationManager as a StateObject at the app level
    @StateObject private var translationManager = TranslationManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(translationManager) // Inject it as an environment object
        }
    }
}
