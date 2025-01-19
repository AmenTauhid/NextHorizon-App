//
//  APIService.swift
//  NextHorizon
//

import Foundation

class APIService {
    func sendMessageToFastAPI(message: String, completion: @escaping (String?, Error?) -> Void) {
        
        guard let url = URL(string: "http://127.0.0.1:8000/generate") else {
            completion(nil, NSError(domain: "InvalidURL", code: 0, userInfo: nil))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["chat_id": "user123", "prompt": message]
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
}
