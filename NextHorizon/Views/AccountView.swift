//
//  AccountView.swift
//  NextHorizon
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
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    ZStack {
                        VStack(spacing: 20) {
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
                            
                            VStack(alignment: .leading, spacing: 15) {
                                InfoRow(icon: "envelope.fill", text: user.email)
                                InfoRow(icon: "person.fill", text: "Student")
                            }
                            .padding()
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Spacer()
                                    TranslatableText(text: "Preferred Language")
                                        .font(.headline)
                                        .padding(.horizontal)
                                    Spacer()
                                }
                                
                                if !translationManager.availableLanguages.isEmpty {
                                    HStack {
                                        Spacer()
                                        Picker("Select Language", selection: $translationManager.currentLanguage) {
                                            ForEach(translationManager.availableLanguages) { language in
                                                Text(language.name)
                                                    .tag(language.language)
                                            }
                                        }
                                        .pickerStyle(MenuPickerStyle())
                                        .padding()
                                        Spacer()
                                    }
                                } else {
                                    ProgressView()
                                        .padding()
                                }
                            }
                            .padding(.vertical)
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            
                            Spacer()
                            
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
                        .padding(.horizontal)
                    }
                    .padding(.top, 20)
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
