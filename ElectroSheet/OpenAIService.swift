//
//  OpenAIService.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/9/29.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

class OpenAIService {
    static let shared = OpenAIService()
    static let modelSelected = ""
    
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
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        print(String(data: data, encoding: .utf8)!)
    }
    
}

struct ChatPayload: Encodable {
    let model: String
    let messages: [GPTMessage]
    let functions: [GPTFunction]
}

struct GPTMessage: Encodable {
    let role: String
    let content: String
}

struct GPTFunction: Encodable {
    let param: GPTFunctionParameters
    
    let name: String
    let description: String
}

struct GPTFunctionParameters: Encodable {
    let type: String
    let properties: [String: GPTFunctionProperty]?
    let required: [String]?
}

struct GPTFunctionProperty: Encodable {
    let type: String
    let description: String
    
}
