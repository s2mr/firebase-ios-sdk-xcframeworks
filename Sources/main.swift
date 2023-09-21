// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

final class Runner {
    public func run() throws {
        let directory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let contents = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
        try contents.forEach { content in
            guard try content.resourceValues(forKeys: [.isDirectoryKey]).isDirectory ?? false else { return }

            try FileManager.default.enumerator(at: content, includingPropertiesForKeys: nil)?.forEach { file in
                guard let file = file as? URL else { return }
                guard file.pathExtension == "xcframework" else { return }

                try FileManager.default.createDirectory(at: directory.appendingPathComponent("Frameworks"), withIntermediateDirectories: true)
                do {
                    try FileManager.default.moveItem(at: file, to: directory.appendingPathComponent("Frameworks").appendingPathComponent(file.lastPathComponent))
                }
                catch let error as NSError {
                    switch error.code {
                    case NSFileWriteFileExistsError:
                        print(file.lastPathComponent, "is exists")

                    default:
                        print("!!!", error)
                    }
                }
            }
        }
    }
}

try Runner().run()
