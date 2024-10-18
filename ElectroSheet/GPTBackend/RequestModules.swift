//
//  RequestModules.swift
//  ElectroSheet
//
//  Created by DJShabsifhe on 2024/10/1.
//

import Foundation

struct ChatPayload: Encodable {
    let model: String
    let messages: [GPTMessage]
    let functions: [GPTFunction]
}

struct GPTMessage: Encodable, Equatable {
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
