//
//  JobBoardView.swift
//  NextHorizon
//
//  Created by Omar Al dulaimi on 2025-01-18.
//

import Foundation
import SwiftUI
struct JobBoardView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Find Your Next Opportunity")
                    .font(.title)
                    .padding()
                
                Text("Coming soon: Student job listings and internships")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .navigationBarTitle("Job Board", displayMode: .inline)
        }
    }
}
