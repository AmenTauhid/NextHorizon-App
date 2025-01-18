//
//  ContentView.swift
//  NextHorizon
//
//  Created by Ayman Tauhid on 2025-01-18.
//

import SwiftUI
import Auth0


struct ContentView: View {
    @State private var user: User?
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            if let user = user {
                VStack {
                    Text("Welcome!")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("Email: \(user.email)")
                        .padding()
                    
                    Button(action: logout) {
                        Text("Logout")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .navigationBarTitle("Home", displayMode: .inline)
            } else {
                VStack {
                    Text("TestApp")
                        .font(.largeTitle)
                        .padding()
                    
                    Button(action: login) {
                        Text("Login")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .navigationBarTitle("Welcome", displayMode: .inline)
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { showError = false }
        } message: {
            Text(errorMessage)
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
