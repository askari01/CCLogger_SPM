//
//  LogLevel.swift
//  CCLogger
//
//  Created by Andrzej Jacak on 12/09/2018.
//  Copyright © 2018 Cybercom Poland Sp. z o.o. All rights reserved.
//

import Foundation

public enum LogLevel {
    case debug
    case sensitiveData
    case info
    case error

    var shortIdentifier: String {
        switch self {
        case .debug:
            return "D"
        case .sensitiveData:
            return "S"
        case .info:
            return "I"
        case .error:
            return "E"
        }
    }

    var all: Set<LogLevel> { Set<LogLevel>([.debug, .error, .info, .sensitiveData]) }

    #if DEBUG
    public static let defaultLevels: Set<LogLevel> = [.debug, .error, .info, .sensitiveData]
    #else
    public static let defaultLevels: Set<LogLevel> = [.error, .info]
    #endif
}
