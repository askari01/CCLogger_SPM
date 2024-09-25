//
//  Default.swift
//  CCLogger
//
//  Created by Andrzej Jacak on 12/09/2018.
//  Copyright © 2018 Cybercom Poland Sp. z o.o. All rights reserved.
//

import Foundation

#if DEBUG
    public let debugLogger: Logger? = Logger(level: .debug, loggerNamePrefix: nil, temporaryPrefix: nil)
    public let errorLogger = Logger(level: .error, loggerNamePrefix: nil, temporaryPrefix: nil)
    public let infoLogger = Logger(level: .info, loggerNamePrefix: nil, temporaryPrefix: nil)
    public let sensitiveDataLogger: Logger? = Logger(level: .sensitiveData, loggerNamePrefix: nil, temporaryPrefix: nil)
#else
    public let debugLogger: Logger? = nil
    public let errorLogger = Logger(level: .error, loggerNamePrefix: nil, temporaryPrefix: nil)
    public let infoLogger = Logger(level: .info, loggerNamePrefix: nil, temporaryPrefix: nil)
    public let sensitiveDataLogger: Logger? = nil
#endif
