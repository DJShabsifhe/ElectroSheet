import SwiftUI

struct ImportPDFView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var openAIHandler: OpenAIHandler
    @State private var isImporting: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack {
            Text("导入 PDF 并转换为 JSON")
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                isImporting = true
            }) {
                Text("选择 PDF 文件")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.pdf]) { result in
                switch result {
                case .success(let url):
                    importPDF(from: url)
                case .failure(let error):
                    alertMessage = "导入失败: \(error.localizedDescription)"
                    showAlert = true
                }
            }
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("提示"), message: Text(alertMessage), dismissButton: .default(Text("确定")))
        }
    }
    
    private func importPDF(from url: URL) {
        openAIHandler.importPDFAndConvertToJSON(pdfURL: url) { result in
            switch result {
            case .success(let partItem):
                alertMessage = "成功导入: \(partItem.name)"
                showAlert = true
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                alertMessage = "转换失败: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}

struct ImportPDFView_Previews: PreviewProvider {
    static var previews: some View {
        ImportPDFView(openAIHandler: OpenAIHandler())
    }
}