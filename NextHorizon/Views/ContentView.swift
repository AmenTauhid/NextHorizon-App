import SwiftUI
import Auth0

struct ContentView: View {
    @State private var user: User?
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var selectedTab = 0
    @EnvironmentObject private var translationManager: TranslationManager
    @State private var translatedErrorTitle: String = "Error"
    @State private var translatedOK: String = "OK"
    
    var body: some View {
        ZStack {
            if let user = user {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            TranslatableText(text: "My Path")
                        }
                        .tag(0)
                    
                    JobBoardView()
                        .tabItem {
                            Image(systemName: "doc.text.magnifyingglass")
                            TranslatableText(text: "Job Search")
                        }
                        .tag(1)
                    
                    CareerBoardView()
                        .tabItem {
                            Image(systemName: "briefcase.fill")
                            TranslatableText(text: "Career Explorer")
                        }
                        .tag(2)
                    
                    AccountView(user: user, logout: logout)
                        .tabItem {
                            Image(systemName: "person.fill")
                            TranslatableText(text: "Account")
                        }
                        .tag(3)
                }
                .accentColor(.blue)
            } else {
                LandingView(login: login)
            }
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text(translatedErrorTitle),
                message: Text(errorMessage),
                dismissButton: .default(Text(translatedOK))
            )
        }
        .onAppear {
            translateAlertTexts()
        }
        .onChange(of: translationManager.currentLanguage) { _ in
            translateAlertTexts()
        }
    }
    
    private func translateAlertTexts() {
        Task {
            translatedErrorTitle = await translationManager.translate("Error")
            translatedOK = await translationManager.translate("OK")
        }
    }
    
    private func login() {
        Auth0
            .webAuth()
            .start { result in
                switch result {
                case .success(let credentials):
                    self.user = User(from: credentials.idToken)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
    }
    
    private func logout() {
        Auth0
            .webAuth()
            .clearSession { result in
                switch result {
                case .success:
                    self.user = nil
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
    }
}
