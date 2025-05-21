//
//  ErrorCode.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 18/05/25.
//

enum WCErrorCode: Int {
    case genericError = 7001
    case sessionNotSupported = 7002
    case sessionMissingDelegate = 7003
    case sessionNotActivated = 7004
    case deviceNotPaired = 7005
    case watchAppNotInstalled = 7006
    case notReachable = 7007
    case invalidParameter = 7008
    case payloadTooLarge = 7009
    case payloadUnsupportedTypes = 7010
    case messageReplyFailed = 7011
    case messageReplyTimedOut = 7012
    case fileAccessDenied = 7013
    case deliveryFailed = 7014
    case insufficientSpace = 7015
    case sessionInactive = 7016
    case transferTimedOut = 7017
    case companionAppNotInstalled = 7018
}
