//
//  AccountView.swift
//  NextHorizon
//
//  Created by Omar Al dulaimi on 2025-01-18.
//

import Foundation
import SwiftUI


struct AccountView: View {
    let user: User
    let logout: () -> Void
    @EnvironmentObject private var translationManager: TranslationManager
    @State private var translatedTitle: String = "Account"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Profile Image
                AsyncImage(url: URL(string: user.picture)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                } placeholder: {
                    ProgressView()
                        .frame(width: 120, height: 120)
                }
                .padding(.top, 20)
                
                // User Info Section
                VStack(alignment: .leading, spacing: 15) {
                    InfoRow(icon: "envelope.fill", text: user.email)
                    InfoRow(icon: "person.fill", text: "Student")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Language Selection
                VStack(alignment: .leading, spacing: 10) {
                    TranslatableText(text: "Preferred Language")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if !translationManager.availableLanguages.isEmpty {
                        Picker("Select Language", selection: $translationManager.currentLanguage) {
                            ForEach(translationManager.availableLanguages) { language in
                                Text(language.name)
                                    .tag(language.language)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                    } else {
                        ProgressView()
                            .padding()
                    }
                }
                .padding(.vertical)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                
                Spacer()
                
                // Logout Button
                Button(action: logout) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                        TranslatableText(text: "Sign Out")
                    }
                    .frame(minWidth: 200)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.bottom, 30)
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
            translatedTitle = await translationManager.translate("Account")
        }
    }
}


struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            TranslatableText(text: text)
            Spacer()
        }
    }
}
