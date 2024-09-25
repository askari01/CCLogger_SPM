//
//  MultiLogger.swift
//  CCLogger
//
//  Created by Andrzej Jacak on 13/09/2018.
//  Copyright © 2018 Cybercom Poland Sp. z o.o. All rights reserved.
//

import Foundation

public class MultiLogger {
    public init(debug: Logger?, error: Logger?, info: Logger?, sensitiveData: Logger?) {
        self.debug = debug
        self.error = error
        self.info = info
        self.sensitiveData = sensitiveData
    }

    public init(namePrefix: String?, levels: Set<LogLevel>, customFileLogger: FileLogger? = nil) {
        if levels.contains(.debug) {
            debug = Logger(level: .debug, loggerNamePrefix: namePrefix, temporaryPrefix: nil, customFileLogger: customFileLogger)
        } else {
            debug = nil
        }

        if levels.contains(.error) {
            error = Logger(level: .error, loggerNamePrefix: namePrefix, temporaryPrefix: nil, customFileLogger: customFileLogger)
        } else {
            error = nil
        }

        if levels.contains(.info) {
            info = Logger(level: .info, loggerNamePrefix: namePrefix, temporaryPrefix: nil, customFileLogger: customFileLogger)
        } else {
            info = nil
        }

        if levels.contains(.sensitiveData) {
            sensitiveData = Logger(level: .sensitiveData, loggerNamePrefix: namePrefix, temporaryPrefix: nil, customFileLogger: customFileLogger)
        } else {
            sensitiveData = nil
        }
    }

    public static let shared = MultiLogger(debug: debugLogger,
                                           error: errorLogger,
                                           info: infoLogger,
                                           sensitiveData: sensitiveDataLogger)

    public func logger(_ level: LogLevel) -> Logger? {
        switch level {
        case .debug: return debug
        case .error: return error
        case .info: return info
        case .sensitiveData: return sensitiveData
        }
    }

    public let debug: Logger?
    public let error: Logger?
    public let info: Logger?
    public let sensitiveData: Logger?
}
