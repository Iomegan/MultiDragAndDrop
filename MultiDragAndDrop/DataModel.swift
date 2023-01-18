//
//  DataModel.swift
//  MultiDragAndDrop
//
//  Created by Daniel Witt on 02.01.23.
//

import CoreTransferable
import UniformTypeIdentifiers

class SidebarItem: NSObject, ObservableObject, Identifiable {
    var id = UUID()
    @Published var detailItems: [DetailItem]

    init(detailItems: [DetailItem]) {
        self.detailItems = detailItems
    }
}

class DetailItem: NSObject, ObservableObject, Identifiable {
    static var tempDirectoryURL: URL = {
        let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("MultiDragAndDropApp")
        do {
            try FileManager.default.createDirectory(at: tempDirURL, withIntermediateDirectories: true, attributes: nil)
        }
        catch {
            return tempDirURL
        }
        return tempDirURL
    }()!
    
    var id = UUID()
    
    init(id: UUID = UUID()) {
        self.id = id
    }
    
    var fileURL: URL {
        let fileManager = FileManager.default
        let fileName = "\(id.uuidString)"
        var tempDirectoryFileURL = URL(fileURLWithPath: "\(Self.tempDirectoryURL.path)/\(fileName).txt")
        for i in 0 ... 9999 {
            if fileManager.fileExists(atPath: tempDirectoryFileURL.path) {
                tempDirectoryFileURL = URL(fileURLWithPath: "\(Self.tempDirectoryURL.path)/\(fileName) \(i + 1).txt")
            }
            else {
                break
            }
        }
        
        let path = tempDirectoryFileURL.path
        
        do {
            let data = id.uuidString.data(using: .utf16)
            
            if fileManager.fileExists(atPath: path) {
                NSLog(path)
                try FileManager.default.removeItem(at: tempDirectoryFileURL)
            }
            try data?.write(to: tempDirectoryFileURL)
        }
        catch {
            fatalError(error.localizedDescription)
        }
        
        return tempDirectoryFileURL
    }
}

extension DetailItem: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.id.uuidString) // For drag and drop within the app
//		FileRepresentation(exportedContentType: .fileURL) { item in
//			SentTransferredFile(item.fileURL)
//		} //Not working, using ProxyRepresentation instead
        ProxyRepresentation { detailItem in
            detailItem.fileURL // WORKAROUND: Use file URl in ProxyRepresentation as FileRepresentation does not seem to work: https://developer.apple.com/forums/thread/708794
        }
    }
}

//extension Array: Transferable where Element: DetailItem { // Not working as expected
//    static var transferRepresentation: some TransferRepresentation {
//       ???
//    }
//}
