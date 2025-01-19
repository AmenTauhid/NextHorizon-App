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
                NavigationView {
                    VStack(spacing: 0) {
                        Group {
                            if selectedTab == 0 {
                                HomeView()
                            } else if selectedTab == 1 {
                                JobBoardView()
                            } else if selectedTab == 2 {
                                CareerBoardView()
                            } else if selectedTab == 3 {
                                AccountView(user: user, logout: logout)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        HStack {
                            navBarItem(icon: "house.fill", tag: 0)
                            navBarItem(icon: "doc.text.magnifyingglass", tag: 1)
                            navBarItem(icon: "briefcase.fill", tag: 2)
                            navBarItem(icon: "person.fill", tag: 3)
                        }
                        .padding()
                        .background(
                            Color(hex: "083221")
                                .cornerRadius(25)
                        )
                        .foregroundColor(.white)
                    }
                    .navigationBarHidden(true)
                }
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
    
    private func navBarItem(icon: String, tag: Int) -> some View {
        Image(systemName: icon)
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .padding()
            .foregroundColor(selectedTab == tag ? .white : .gray)
            .font(selectedTab == tag ? .system(size: 40, weight: .bold) : .system(size: 40))
            .onTapGesture {
                selectedTab = tag
            }
            .frame(maxWidth: .infinity)
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
