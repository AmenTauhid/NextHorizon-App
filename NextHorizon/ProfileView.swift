//
//  ProfileView.swift
//  NextHorizon
//
//  Created by Omar Al dulaimi on 2025-01-18.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    let user: User

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: user.picture)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
            Text("Email: \(user.email)")
                .padding()
        }
    }
}
