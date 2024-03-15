import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    
    @State var isShow = false
    var userData: Data {
        let user = User(
            name: "name",
            nickname: "nickname",
            id: 1
        )
        return try! JSONEncoder().encode(user)
    }
    
    var body: some View {
        Button("Button") {
            self.isShow = true
        }
        .fileExporter(
            isPresented: $isShow,
            document: JsonDocument(json: userData),
            contentType: .json,
            defaultFilename: "User",
            onCompletion: { result in
                print(result)
            }
        )
    }
}

struct User: Codable {
    let name: String
    let nickname: String
    let id: Int
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
