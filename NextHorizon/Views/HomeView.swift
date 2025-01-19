//
//  HomeView.swift
//  NextHorizon
//

import SwiftUI

struct HomeView: View {
    private let userName = "Omar"
    private let currentSchooling = "High School Junior"
    private let recommendedJobs = [
        "Software Developer",
        "Data Analyst",
        "Graphic Designer"
    ]
    private let jobDescriptions: [String: String] = [
        "Software Developer": "Build and maintain software applications.",
        "Data Analyst": "Analyze data to uncover insights.",
        "Graphic Designer": "Create visual content for various media."
    ]
    private let jobPaths: [String: String] = [
        "Software Developer": "Bachelor's in Computer Science or Coding Bootcamp",
        "Data Analyst": "Bachelor's in Statistics or Data Science Certification",
        "Graphic Designer": "Associate's Degree or Portfolio with Certifications"
    ]

    @State private var selectedJob: String? = nil

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Welcome Section
                        Text("Welcome back, \(userName)!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 20)

                        Text("Discover your future career and how to get there.")
                            .font(.subheadline)

                        Divider()

                        // Recommended Careers Section
                        Text("Recommended Careers")
                            .font(.headline)

                        HStack(spacing: 0) {
                            ForEach(recommendedJobs, id: \.self) { job in
                                VStack {
                                    Text(job)
                                        .font(.system(size: 16, weight: .bold))
                                    Text(jobDescriptions[job] ?? "Description not available")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(selectedJob == job ? Color.yellow : Color.yellow.opacity(0.3))
                                .cornerRadius(10)
                                .shadow(radius: 2)
                                .onTapGesture {
                                    selectedJob = job
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }

                        Divider()

                        // Schooling Section
                        Text("Schooling")
                            .font(.headline)

                        if let selectedJob = selectedJob {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Based on your selection, here's the recommended schooling for \(selectedJob):")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                Text(jobPaths[selectedJob] ?? "Path not available")
                                    .font(.system(size: 16))
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 2)

                                Button(action: {
                                    // Action to show schools offering the program
                                    print("Show schools for \(selectedJob)")
                                }) {
                                    HStack{
                                        Image(systemName: "safari")
                                        Text("See Schools Offering This Program")
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                }
                            }
                        } else {
                            Text("Please select a career to see recommended schooling.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        Divider()

                        // Current Schooling Section
                        Text("Current Schooling")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("You are currently enrolled as:")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(currentSchooling)
                                .font(.system(size: 16))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                        }
                        
                        Divider()

                        // Features Section
                        Text("App Features")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 10) {
                            FeatureRow(icon: "house.fill",
                                       title: "Homepage",
                                       description: "Access all your career and schooling information at a glance. Get personalized schooling recommendations based on your chosen career path.")
                            FeatureRow(icon: "message.fill",
                                       title: "Career Advisor",
                                       description: "Chat with our bot to learn about and explore career options, understand your interests, and plan your future.")
                            FeatureRow(icon: "briefcase.fill",
                                       title: "Job Board",
                                       description: "Find the most recent and relevant job postings tailored to your preferences, including details about salary, location, and required qualifications.")
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(Color(hex: "083221"))
                .padding(.trailing, 10)

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
