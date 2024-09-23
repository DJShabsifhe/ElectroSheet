import Foundation
import SwiftUI
import PDFKit

class OpenAIHandler: ObservableObject {
    @Published var parts: [PartItem] = []
    
    private let apiKey = "YOUR_OPENAI_API_KEY" // 替换为实际 API 密钥
    
    func importPDFAndConvertToJSON(pdfURL: URL, completion: @escaping (Result<PartItem, Error>) -> Void) {
        do {
            guard let pdfDocument = PDFDocument(url: pdfURL) else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "无法加载 PDF 文档"])))
                return
            }
            
            var pdfText = ""
            
            for pageIndex in 0..<pdfDocument.pageCount {
                if let page = pdfDocument.page(at: pageIndex), let pageString = page.string {
                    pdfText += pageString
                }
            }
            
            let openAIResponse = callOpenAIAPI(with: pdfText)
            
            switch openAIResponse {
            case .success(let partItem):
                DispatchQueue.main.async {
                    self.parts.append(partItem)
                    self.savePartToJSON(partItem: partItem)
                    completion(.success(partItem))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    private func callOpenAIAPI(with text: String) -> Result<PartItem, Error> {
        return fetchPartItemFromOpenAI(text: text)
    }
    
    private func savePartToJSON(partItem: PartItem) {
        do {
            let jsonData = try JSONEncoder().encode(partItem)
            let fileName = "PartItem.json"
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            try jsonData.write(to: fileURL)
            print("成功保存 JSON 到: \(fileURL)")
        } catch {
            print("保存 JSON 失败: \(error)")
        }
    }
    
    private func fetchPartItemFromOpenAI(text: String) -> Result<PartItem, Error> {
        guard let url = URL(string: "https://api.openai.com/v1/completions") else {
            return .failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "无效的 URL"]))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let prompt = """
        从文本中提取以下信息: name, description, icon, colorString, type, usage, special. 使用以下格式:
        {
            "id": "随机 UUID",
            "name": "从 PDF 中提取的名称",
            "description": "从 PDF 中提取的描述",
            "icon": "widget_a.png",
            "colorString": "blue",
            "isFavorite": true,
            "favoriteDate": "2023-09-10T10:00:00Z",
            "type": "Widget",
            "usage": "Used in devices for automation.",
            "special": "Requires special handling."
        }
        """
        
        let body: [String: Any] = [
            "model": "text-davinci-003",
            "prompt": "\(prompt)\n\n\(text)",
            "max_tokens": 300,
            "temperature": 0.7
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
        } catch {
            return .failure(error)
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<PartItem, Error>!
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            defer { semaphore.signal() }
            
            if let error = error {
                result = .failure(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                result = .failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "OpenAI API 响应无效"]))
                return
            }
            
            guard let data = data else {
                result = .failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "没有接收到数据"]))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let text = choices.first?["text"] as? String {
                    
                    // 清理返回的文本
                    let cleanedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    // 将文本转换为 PartItem
                    let partData = cleanedText.data(using: .utf8)!
                    let partItem = try JSONDecoder().decode(PartItem.self, from: partData)
                    
                    result = .success(partItem)
                } else {
                    result = .failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "无法解析 OpenAI API 的响应"]))
                }
            } catch {
                result = .failure(error)
            }
        }.resume()
        
        semaphore.wait()
        return result
    }
}

struct OpenAIResponse: Codable {
    let name: String
    let description: String
    let icon: String
    let colorString: String
    let type: String
    let usage: String
    let special: String
}
