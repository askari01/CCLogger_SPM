//
//  Logger.swift
//  CCLogger
//
//  Created by Andrzej Jacak on 12/09/2018.
//  Copyright © 2018 Cybercom Poland Sp. z o.o. All rights reserved.
//

import Foundation

public class Logger {
    public let level: LogLevel

    init(level: LogLevel, loggerNamePrefix: String? = nil, temporaryPrefix: String? = nil, customFileLogger: FileLogger? = nil) {
        self.level = level
        self.namePrefix = loggerNamePrefix
        self.temporaryPrefix = temporaryPrefix
    }
    var namePrefix: String?
    var temporaryPrefix: String?
    var customFileLogger: FileLogger?

    public enum AdditionalInfo {
        /// Calculate time from app start/first log in seconds
        case timeSinceApplicationStart
        case threadName(charactersLimit: Int)
        case levelIdentifier
        case scope
    }

    public var additionalInfo: [AdditionalInfo] = [.timeSinceApplicationStart,
                                                   .threadName(charactersLimit: 4),
                                                   .levelIdentifier,
                                                   .scope]

    open func log(_ message: String) {
        log(message, scope: nil)
    }

    open func log(_ message: String, scope: String? = nil) {

        var parts: [String] = []
        for info in additionalInfo {
            switch info {
            case .timeSinceApplicationStart:
                parts.append(SharedLoggerTools.timeSinceStart)
            case .threadName(let charactersLimit):
                guard charactersLimit > 0 else { continue }

                var threadName = ""
                if Thread.current.isMainThread {
                    threadName = Thread.current.name ?? ""
                    if threadName.isEmpty {
                        threadName = "MAIN"
                    }
                } else {
                    threadName = Thread.current.name ?? ""
                }
                threadName = String(threadName.prefix(charactersLimit))

                for _ in threadName.count..<charactersLimit {
                    threadName.append(" ")
                }
                parts.append(threadName)
            case .levelIdentifier:
                parts.append(level.shortIdentifier)
            case .scope:
                parts.append(scope ?? "")
            }
        }

        var formattedMessage = parts.joined(separator: "|")

        if let namePrefix = namePrefix {
            formattedMessage += namePrefix
        }

        if let temporaryPrefix = temporaryPrefix {
            if formattedMessage.isEmpty == false {
                formattedMessage += " "
            }
            formattedMessage += temporaryPrefix
        }

        formattedMessage += " " + message
        CCLoggerConfiguration.shared.customPrintHandler?(formattedMessage)
        print(formattedMessage)
        (customFileLogger ?? CCLoggerConfiguration.shared.fileLogger)?.log(text: formattedMessage, level: level)
    }
}
