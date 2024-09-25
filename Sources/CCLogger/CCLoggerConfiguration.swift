//
//  CCLoggerConfiguration.swift
//  CCLogger
//
//  Created by Andrzej Jacak on 13/09/2018.
//  Copyright © 2018 Cybercom Poland Sp. z o.o. All rights reserved.
//

import Foundation

public class CCLoggerConfiguration {
    public static let shared = CCLoggerConfiguration()
    public var customPrintHandler: ((String) -> Void)?
    public var fileLogger: FileLogger?
}
