//
//  CareerBoardView.swift
//  NextHorizon
//

import Foundation
import SwiftUI

struct CareerBoardView: View {
    @EnvironmentObject private var translationManager: TranslationManager
    @State private var translatedTitle: String = "Career Advisor"
    @StateObject private var viewModel = ChatViewModel()
    
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
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.messages) { message in
                                MessageView(message: message)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    
                    HStack {
                        TextField("Type your message", text: $viewModel.newMessageText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        Button(action: {
                            viewModel.sendMessage(translationManager: translationManager)
                        }) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.blue)
                        }
                        .padding(.trailing)
                    }
                    .padding(.vertical)
                }
                .navigationBarTitle(translatedTitle)
                .onAppear {
                    translateNavigationTitle()
                }
                .onChange(of: translationManager.currentLanguage) { _ in
                    translateNavigationTitle()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.clearChat()
                        }) {
                            Text("New Chat")
                        }
                    }
                }
            }
        }
        .translatePage()
    }
    
    private func translateNavigationTitle() {
        Task {
            translatedTitle = await translationManager.translate("Career Advisor")
        }
    }
}

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var newMessageText: String = ""
    
    private let apiService = APIService()
    private let welcomeMessage = "Hi there! I'm your career advisor. I'm here to help you explore career options, understand your interests, and plan your future. What's on your mind today?"
    
    init() {
        messages.append(Message(text: welcomeMessage, isUser: false))
    }
    
    func sendMessage(translationManager: TranslationManager) {
        let userMessage = Message(text: newMessageText, isUser: true)
        messages.append(userMessage)
        newMessageText = ""
        
        apiService.sendMessageToFastAPI(
            message: userMessage.text,
            translationManager: translationManager
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.messages.append(Message(text: response, isUser: false))
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    // Optionally show error message to user
                }
            }
        }
    }
    
    func clearChat() {
        messages = [Message(text: welcomeMessage, isUser: false)]
        apiService.clearTranslations()
    }
}

struct MessageView: View {
    let message: Message
    @EnvironmentObject private var translationManager: TranslationManager
    @State private var translatedText: String = ""
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.text)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            } else {
                ScrollView {
                    Text(translatedText)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(15)
                }
                Spacer()
            }
        }
        .onAppear {
            translateMessage()
        }
        .onChange(of: translationManager.currentLanguage) { _ in
            translateMessage()
        }
    }
    
    private func translateMessage() {
        if !message.isUser {
            Task {
                let formattedText = formatResponse(message.text)
                translatedText = await translationManager.translate(formattedText)
            }
        } else {
            translatedText = message.text
        }
    }
    
    private func formatResponse(_ text: String) -> String {
        text.replacingOccurrences(of: "|n", with: "\n")
            .replacingOccurrences(of: "In-", with: "\n- ")
            .replacingOccurrences(of: "nlf", with: "\n")
            .replacingOccurrences(of: "In", with: "\n")
    }
}
