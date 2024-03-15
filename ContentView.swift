import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    
    @State var isShow = false
    let json = "Hello World".data(using: .utf8) ?? .init()
    
    var body: some View {
        Button("Button") {
            self.isShow = true
        }
        .fileExporter(
            isPresented: $isShow,
            document: JsonDocument(json: json),
            contentType: .json,
            defaultFilename: "test",
            onCompletion: { result in
                print(result)
            }
        )
    }
}

struct JsonDocument: FileDocument {
    
    static var readableContentTypes: [UTType] { [.json] }
    var json: Data
    
    init(configuration: ReadConfiguration) throws {
        guard
            let data = configuration.file.regularFileContents
        else { throw NSError() }
        self.json = data
    }
    
    init(json: Data) {
        self.json = json
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: self.json)
    }
}
