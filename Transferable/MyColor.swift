import Foundation
import CoreTransferable
import UniformTypeIdentifiers

struct MyColor: Codable {
    let r: Float
    let g: Float
    let b: Float
}

extension MyColor: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .json) { mixedColor in
            let jsonEncoder: JSONEncoder = .init()
            jsonEncoder.outputFormatting = .prettyPrinted
            let data: Data = try jsonEncoder.encode(mixedColor)
            
            let url: URL = FileManager
                .default
                .temporaryDirectory
                .appending(path: "mixed_color", directoryHint: .notDirectory)
                .appendingPathExtension(UTType.json.preferredFilenameExtension ?? "json")
                
            try data.write(to: url, options: .atomic)
            
            let result: SentTransferredFile = .init(url, allowAccessingOriginalFile: true)
            return result
        } importing: { receivedTransferredFile in
            let data: Data = try .init(contentsOf: receivedTransferredFile.file)
            let jsonDecoder: JSONDecoder = .init()
            let result: MyColor = try jsonDecoder.decode(MyColor.self, from: data)
            return result
        }
    }
}
