//
//  JobListView.swift
//  NextHorizon
//
//  Created by Ayman Tauhid on 2025-01-19.
//

import Foundation
import SwiftUI
// MARK: - Job List View

struct JobList: View {
    @StateObject private var networkManager = APIService()

    var body: some View {
        NavigationView {
            List(networkManager.jobs) { job in
                NavigationLink(destination: JobDetail(job: job)) {
                    VStack(alignment: .leading) {
                        Text(job.job_title ?? "Unknown Job Title").font(.headline)
                        Text(job.company ?? "Unknown Company").font(.subheadline)
                    }
                }
            }
            .navigationTitle("Job Listings")
            .task {
                await networkManager.fetchData()
            }
        }
    }
}
