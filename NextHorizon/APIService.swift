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

class APIService {
    // Rest of the APIService implementation remains the same...
    private let baseURL = "http://127.0.0.1:8000"
    private let chatID = "user123"
    
    enum APIError: Error {
        case invalidURL
        case noData
        case decodingError
        case networkError(Error)
        
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
            }
        }
    }
    
    func sendMessageToFastAPI(message: String, completion: @escaping (Result<String, APIError>) -> Void) {
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
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                let cleanedResponse = responseString.cleanFormattedResponse()
                completion(.success(cleanedResponse))
            } else {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
