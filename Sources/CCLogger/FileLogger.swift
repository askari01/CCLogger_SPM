//
//  FileLogger.swift
//  CCLogger
//
//  Created by Andrzej Jacak on 31/03/2021.
//  Copyright © 2021 Cybercom Poland Sp. z o.o. All rights reserved.
//

import UIKit

public class FileLogger {
    /// Serial queue to write logs from any thread
    private let dispatchQueue: DispatchQueue

    public init(levelsToLog: Set<LogLevel>,
                fileSaveStrategy: FileSaveStrategy,
                logsDirectoryURL: URL) {
        self.levelsToLog = levelsToLog
        self.fileSaveStrategy = fileSaveStrategy
        self.logsDirectoryURL = logsDirectoryURL
        self.dispatchQueue = DispatchQueue(label: "FileLogger(\(logsDirectoryURL.path))", qos: .utility)

        if case .saveWhenAppGoesToBackground = fileSaveStrategy {
            NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification,
                                                   object: nil,
                                                   queue: nil) { [weak self] (_) in
                self?.dispatchQueue.async { [weak self] in
                    self?.applicationDidEnterBackground()
                }
            }
        }
    }

    open var levelsToLog = Set<LogLevel>()
    public let logsDirectoryURL: URL

    public enum FileSaveStrategy {
        /// Save after each log - this may be not very optimal and causes performance issues
        case saveAfterEachLog

        /// Save logs to file when app goes to background or we have to much unsaved logs
        case saveWhenAppGoesToBackground(maxUnsavedLogs: Int)
    }

    public let fileSaveStrategy: FileSaveStrategy

    private var _currentFileName: String?
    public var currentFileName: String {
        if let currentFileName = _currentFileName {
            return currentFileName
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH.mm.ss"
        let dateString = formatter.string(from: Date())
        let newFileName = "\(dateString).txt"
        _currentFileName = newFileName
        return newFileName
    }
    public var logsFileURL: URL {
        logsDirectoryURL.appendingPathComponent(currentFileName, isDirectory: false)
    }

    private var bufferedLines = [String]()

    open func log(text: String, level: LogLevel) {
        dispatchQueue.async { [weak self] in
            guard let self = self, self.levelsToLog.contains(level) else { return }

            switch self.fileSaveStrategy {
            case .saveAfterEachLog:
                self.saveToFile(logs: [text])
            case .saveWhenAppGoesToBackground(let maxUnsavedLogs):
                self.bufferedLines.append(text)
                if self.bufferedLines.count > maxUnsavedLogs {
                    //Save to file and clear bufferedLines
                    self.saveToFile(logs: self.bufferedLines)
                    self.bufferedLines.removeAll()
                }
            }
        }
    }

    /// Force saving all buffered data to file now (for example just before exporting saved log)
    public func saveToFileNow() {
        dispatchQueue.async { [weak self] in
            guard let self = self, !self.bufferedLines.isEmpty else { return }
            self.saveToFile(logs: self.bufferedLines)
            self.bufferedLines.removeAll()
        }
    }

    /// Executed on dispatchQueue
    private func saveToFile(logs: [String]) {
        let joined = logs.joined(separator: "\n")
        guard let data = joined.data(using: .utf8) else { return }

        if FileManager.default.fileExists(atPath: logsFileURL.path) {
            do {
                if let fileHandle = FileHandle(forWritingAtPath: logsFileURL.path) {
                    if #available(iOS 13.4, *) {
                        try fileHandle.seekToEnd()
                        try fileHandle.write(contentsOf: data)
                    } else {
                        fileHandle.seekToEndOfFile()
                        fileHandle.write(data)
                    }

                    if #available(iOS 13.0, *) {
                        try fileHandle.close()
                    } else {
                        fileHandle.closeFile()
                    }
                }
            } catch {
                print("Failed to write: \(data.count) bytes to existing log file:\(logsFileURL) error:\(error)")
            }
        } else {
            do {
                try data.write(to: logsFileURL, options: .atomicWrite)
            } catch {
                print("Failed to write: \(data.count) bytes to new empty log file:\(logsFileURL) error:\(error)")
            }
        }
    }

    /// Executed on dispatchQueue
    private func applicationDidEnterBackground() {
        guard case .saveWhenAppGoesToBackground = fileSaveStrategy else { return }
        saveToFileNow()
    }
}
