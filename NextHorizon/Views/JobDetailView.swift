//
//  JobDetailView.swift
//  NextHorizon
//
//  Created by Ayman Tauhid on 2025-01-19.
//

import Foundation
import SwiftUI

struct JobDetail: View {
    let job: Job

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(job.job_title ?? "Unknown Job Title")
                    .font(.title)
                    .padding()

                Text(job.company ?? "Unknown Company")
                    .font(.headline)
                    .padding()

                Text("Location: \(job.location ?? "Unknown Location")")
                    .padding()

                Text("Date Posted: \(job.date_posted ?? "Unknown Date")")
                    .padding()

                Text(job.description ?? "No Description Available")
                    .padding()

                if let urlString = job.url, let url = URL(string: urlString) {
                    Link("View on Indeed", destination: url)
                        .padding()
                }
            }
        }
    }
}
