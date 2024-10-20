//
//  OpenAIService.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/29.
//

import Foundation
import OpenAI

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

class OpenAIService {
    
    // Alternative
    let openAI = OpenAI(apiToken: Secrets.apiKey)


    static let shared = OpenAIService()
    static let modelSelected = "gpt-3.5-turbo"
    
    private init() { }
    
    private func generateURLRequest(httpMethod: HTTPMethod, message: String) throws -> URLRequest {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions")
        else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(Secrets.apiKey)", forHTTPHeaderField: "Authorization")

        print("Request Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")

        let systemMessage = GPTMessage(role: "system", content: "You are a helpful assistant in Electronic Engineering and knows lots of information about electronic parts.")
        
        let userMessage = GPTMessage(role: "user", content: message)
        
        let name = GPTFunctionProperty(type: "string", description: "The name of the part. e.g. NE555")
        
        let description = GPTFunctionProperty(type: "string", description: "The description of that part in one line.")
        
        let icon = GPTFunctionProperty(type: "string", description: "Select an icon from 'globe', 'heart', 'star', and 'bell'.")
        
        let colorString = GPTFunctionProperty(type: "string", description: "Select a color for the part, from 'blue', 'green', 'red', 'yellow', and 'purple'. This can be the color of the manufacturer or the color of board in the photo")
        
        let params: [String: GPTFunctionProperty] = [
            "name": name,
            "description": description,
            "icon": icon,
            "colorString": colorString
        ]
        
        let functionParams = GPTFunctionParameters(type: "object", properties: params, required: ["name", "description", "icon", "colorString"])
        
        let function = GPTFunction(param: functionParams, name: "get_info", description: "Get the info for a given electronic part.")
        
        let payload = ChatPayload(model: OpenAIService.modelSelected, messages: [systemMessage, userMessage], functions: [function])
        
        let jsonData = try JSONEncoder().encode(payload)
        
        urlRequest.httpBody = jsonData
        
        return URLRequest(url: url)
    }
    
    func sendPrompt(message: String) async throws {
        let urlRequest = try generateURLRequest(httpMethod: .post, message: message)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // Print the raw response data
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code: \(httpResponse.statusCode)")
        }
        print("Raw response data: \(String(data: data, encoding: .utf8) ?? "No data")")
        
        do {
            let result = try JSONDecoder().decode(GPTResponse.self, from: data)
            print(result)
            print(result.choices[0].message.functionCall)
        } catch {
            print("Decoding error: \(error.localizedDescription)")
            throw error
        }
    }
    
}
