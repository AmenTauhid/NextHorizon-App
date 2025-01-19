//
//  ContentView.swift
//  NextHorizon
//

import SwiftUI
import Auth0

struct ContentView: View {
    @State private var user: User?
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            if let user = user {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("My Path")
                        }
                        .tag(0)
                    
                    JobBoardView()
                        .tabItem {
                            Image(systemName: "doc.text.magnifyingglass")
                            Text("Job Search")
                        }
                        .tag(1)
                    
                    CareerBoardView()
                        .tabItem {
                            Image(systemName: "briefcase.fill")
                            Text("Career Explorer")
                        }
                        .tag(2)
                    
                    AccountView(user: user, logout: logout)
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Account")
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
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
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
