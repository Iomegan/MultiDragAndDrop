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

class DetailItem: NSObject, ObservableObject, Identifiable, Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.id.uuidString)
        
        ProxyRepresentation { detailItem in
            detailItem.fileURL // WORKAROUND: Use file URl in ProxyRepresentation as FileRepresentation does not seem to work: https://developer.apple.com/forums/thread/708794
        }
    }
    
    static var tempDirectoryURL: URL = {
        let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("rocket_typist")
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
        //        return URL(filePath: "/Users/danielwitt/Desktop/Today is day 22 of Decembe.rockettypist")
        
        let fileManager = FileManager.default
        let fileName = "\(id.uuidString)"
        var tempDirectoryFileURL = URL(fileURLWithPath: "\(Self.tempDirectoryURL.path)/\(fileName).txt")
        for i in 0 ... 9999 { // no more than 9999 at once
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
            
            if fileManager.fileExists(atPath: path) { // Could happen if more than 999 files with the same name exist
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
