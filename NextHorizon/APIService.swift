import Foundation

struct SearchResults: Decodable {
    let data: [Job]
}

class APIService: ObservableObject {
    @Published var jobs: [Job] = []

    func sendMessageToFastAPI(message: String, completion: @escaping (String?, Error?) -> Void) {
        // Replace with your FastAPI endpoint
        guard let url = URL(string: "http://127.0.0.1:8000/generate") else {
            completion(nil, NSError(domain: "InvalidURL", code: 0, userInfo: nil))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Assuming your FastAPI endpoint expects a JSON body like {"chat_id": "some_id", "prompt": "the message"}
        let body: [String: Any] = ["chat_id": "user123", "prompt": message] // Replace "user123" with a unique chat ID if needed
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "NoData", code: 0, userInfo: nil))
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                completion(responseString, nil)
            } else {
                completion(nil, NSError(domain: "DecodingError", code: 0, userInfo: nil))
            }
        }.resume()
    }

    func fetchData() async {
        guard let url = URL(string: "http://127.0.0.1:8000/jobs/search") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Log the HTTP response status code
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }
            
            print("Raw JSON Data: \(String(data: data, encoding: .utf8) ?? "Invalid JSON")")
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let json = try? decoder.decode(SearchResults.self, from: data) {
                DispatchQueue.main.async {
                    self.jobs = json.data
                }
            } else {
                print("Error: Unable to decode JSON")
            }
        } catch {
            print("Error fetching or decoding data: \(error)")
        }
    }
}
