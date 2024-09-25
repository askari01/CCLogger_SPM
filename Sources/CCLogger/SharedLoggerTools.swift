//
//  SharedLogTools.swift
//  CCLogger
//
//  Created by Andrzej Jacak on 12/09/2018.
//  Copyright © 2018 Cybercom Poland Sp. z o.o. All rights reserved.
//

import Foundation

internal class SharedLoggerTools {
    static var debugStartTime: Date = Date()
    static var timeSinceStart: String {
        return String(format: "%.2f", -1.0 * debugStartTime.timeIntervalSinceNow) + "|"
    }
}
