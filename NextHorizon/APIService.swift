import Foundation

extension String {
    func cleanFormattedResponse() -> String {
        var text = self
        
        // Define quotes character set
        let quotes = CharacterSet(charactersIn: "\"'")
        
        // Remove surrounding quotes if they exist
        text = text.trimmingCharacters(in: quotes)
        
        // Replace escaped newlines with actual newlines
        text = text.replacingOccurrences(of: "\\n", with: "\n")
        
        // Clean up bullet points
        text = text.replacingOccurrences(of: "\\n- ", with: "\n• ")
        text = text.replacingOccurrences(of: "\n- ", with: "\n• ")
        
        // Clean up markdown-style formatting
        text = text.replacingOccurrences(of: "**", with: "")
        text = text.replacingOccurrences(of: "__", with: "")
        
        // Remove extra spaces
        text = text.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .joined(separator: "\n")
        
        // Clean up multiple newlines
        while text.contains("\n\n\n") {
            text = text.replacingOccurrences(of: "\n\n\n", with: "\n\n")
        }
        
        // Clean up other formatting artifacts
        text = text.replacingOccurrences(of: "\\t", with: "    ")
        text = text.replacingOccurrences(of: "\\'", with: "'")
        text = text.replacingOccurrences(of: "\\\"", with: "\"")
        
        return text.trimmingCharacters(in: .whitespaces)
    }
}

actor TranslationState {
    private var translatedMessages: [String: String] = [:]
    
    func getTranslation(for key: String) -> String? {
        return translatedMessages[key]
    }
    
    func setTranslation(_ translation: String, for key: String) {
        translatedMessages[key] = translation
    }
    
    func clearTranslations() {
        translatedMessages.removeAll()
    }
}

struct SearchResults: Decodable {
    let data: [Job]
}

class APIService: ObservableObject {
    @Published var jobs: [Job] = []
    private let baseURL = "http://127.0.0.1:8000"
    private let chatID = "user123"
    private let translationState = TranslationState()
    
    enum APIError: Error {
        case invalidURL
        case noData
        case decodingError
        case networkError(Error)
        case translationError(Error)
        
        var localizedDescription: String {
            switch self {
            case .invalidURL:
                return "Invalid URL configuration"
            case .noData:
                return "No data received from server"
            case .decodingError:
                return "Error decoding server response"
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            case .translationError(let error):
                return "Translation error: \(error.localizedDescription)"
            }
        }
    }
    
    func sendMessageToFastAPI(message: String, translationManager: TranslationManager? = nil, completion: @escaping (Result<String, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/generate") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "chat_id": chatID,
            "prompt": message
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(.decodingError))
            return
        }
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let responseString = String(data: data, encoding: .utf8) else {
                completion(.failure(.decodingError))
                return
            }
            
            let cleanedResponse = responseString.cleanFormattedResponse()
            
            // If no translation manager is provided or the current language is English,
            // return the cleaned response directly
            guard let translationManager = translationManager,
                  translationManager.currentLanguage != "en" else {
                completion(.success(cleanedResponse))
                return
            }
            
            // Translate the response
            Task {
                do {
                    let translatedResponse = await translationManager.translate(cleanedResponse)
                    await self.translationState.setTranslation(translatedResponse, for: cleanedResponse)
                    DispatchQueue.main.async {
                        completion(.success(translatedResponse))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.translationError(error)))
                    }
                }
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
    
    func clearTranslations() {
        Task {
            await translationState.clearTranslations()
        }
    }
}
