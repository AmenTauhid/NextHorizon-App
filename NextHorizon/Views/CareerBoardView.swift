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
                        TextField("Enter your message", text: $viewModel.newMessageText)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        Button(action: {
                            viewModel.sendMessage()
                        }) {
                            Image(systemName: "paperplane.fill")
                                .font(.title2)
                        }
                        .padding(.trailing)
                    }
                    .padding(.bottom)
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
                        Button("New Chat") {
                            viewModel.clearChat()
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
    init() {
        messages.append(Message(text: "Hi there! I'm your career advisor. I'm here to help you explore career options, understand your interests, and plan your future. What's on your mind today?", isUser: false))
    }
    
    func sendMessage() {
        let userMessage = Message(text: newMessageText, isUser: true)
        messages.append(userMessage)
        newMessageText = ""
        
        apiService.sendMessageToFastAPI(message: userMessage.text) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.messages.append(Message(text: response, isUser: false))
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    
                }
            }
        }
    }
    
    func clearChat() {
           messages = [Message(text: "Hi there! I'm your career advisor. I'm here to help you explore career options, understand your interests, and plan your future. What's on your mind today?", isUser: false)]
       }
}

struct MessageView: View {
    let message: Message
    @State private var formattedText: String = ""
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
                    Text(formattedText)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(15)
                }
                Spacer()
            }
        }
        .onAppear {
            formattedText = formatResponse(message.text)
        }
    }
    func formatResponse(_ text: String) -> String {
        var formattedText = text.replacingOccurrences(of: "|n", with: "\n")
                                .replacingOccurrences(of: "In-", with: "\n- ")
                                .replacingOccurrences(of: "nlf", with: "\n")
                                .replacingOccurrences(of: "In", with: "\n")
        return formattedText
    }
}
