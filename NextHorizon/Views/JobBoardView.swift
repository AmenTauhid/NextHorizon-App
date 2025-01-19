//
//  JobBoardView.swift
//  NextHorizon
//

import Foundation
import SwiftUI

struct JobBoardView: View {
    @EnvironmentObject private var translationManager: TranslationManager
    @State private var translatedTitle: String = "Job Board"
    @StateObject private var apiService = APIService()

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
                    TranslatableText(text: "Find Your Next Opportunity")
                        .font(.title)
                        .padding()
                    
                    //                    TranslatableText(text: "Coming soon: Student job listings and internships")
                    //                        .multilineTextAlignment(.center)
                    //                        .padding()
                    
                    List(apiService.jobs) { job in
                        NavigationLink(destination: JobDetail(job: job)) {
                            VStack(alignment: .leading) {
                                Text(job.job_title ?? "Unknown Job Title").font(.headline)
                                Text(job.company ?? "Unknown Company").font(.subheadline)
                            }
                        }
                    }
                    .navigationTitle("Job Listings")
                    .task {
                        await apiService.fetchData()
                    }
                }
                .navigationBarTitle(translatedTitle)
                .onAppear {
                    translateNavigationTitle()
                }
                .onChange(of: translationManager.currentLanguage) { _ in
                    translateNavigationTitle()
                }
            }
        }
        .translatePage()
    }
    
    private func translateNavigationTitle() {
        Task {
            translatedTitle = await translationManager.translate("Job Board")
        }
    }
}
