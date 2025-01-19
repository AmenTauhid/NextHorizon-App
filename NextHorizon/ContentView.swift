import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var newMessageText: String = ""
    
    private let apiService = APIService() // Assuming you have an APIService

    init() {
        // Start with the initial message from the AI
        messages.append(Message(text: "Hi there! I'm your career advisor. I'm here to help you explore career options, understand your interests, and plan your future. What's on your mind today?", isUser: false))
    }
    
    func sendMessage() {
        let userMessage = Message(text: newMessageText, isUser: true)
        messages.append(userMessage)
        newMessageText = ""

        // Send message to FastAPI backend
        apiService.sendMessageToFastAPI(message: userMessage.text) { response, error in
            if let response = response {
                DispatchQueue.main.async {
                    self.messages.append(Message(text: response, isUser: false))
                }
            } else if let error = error {
                print("Error: \(error)")
                // Handle error, possibly display an error message to the user
            }
        }
    }
    
    func clearChat() {
           messages = [Message(text: "Hi there! I'm your career advisor. I'm here to help you explore career options, understand your interests, and plan your future. What's on your mind today?", isUser: false)]
       }
}

struct ContentView: View {
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        NavigationView {
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
                .padding(.bottom) // Add padding to avoid the keyboard overlap
            }
            .navigationTitle("Career Advisor")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("New Chat") {
                        viewModel.clearChat()
                    }
                }
            }
        }
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
                    Text(formattedText) // Use the @State variable here
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                }
                Spacer()
            }
        }
        .onAppear {
            formattedText = formatResponse(message.text) // Update formattedText on appearance
        }
    }

    func formatResponse(_ text: String) -> String {
        // 1. Remove the unwanted tags:
        var formattedText = text.replacingOccurrences(of: "|n", with: "\n")
                                .replacingOccurrences(of: "In-", with: "\n- ")
                                .replacingOccurrences(of: "nlf", with: "\n")
                                .replacingOccurrences(of: "In", with: "\n")

        return formattedText
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
